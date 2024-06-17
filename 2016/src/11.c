#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "common/common.h"
#include "common/dynarray.h"

#define MAX_LINE_LENGTH 256
#define NB_FLOORS 4
#define MAX_ELEMENTS 10
#define N_CHARS 4

static_assert(NB_FLOORS * MAX_ELEMENTS <= 8*sizeof(uint64_t),
        "Check that one element per bit per floor holds in a uint64_t");

/***********
 * Element *
 ***********/

enum type {
    MICROCHIP_TYPE = 0,
    GENERATOR_TYPE,
};

struct element {
    char material[N_CHARS+1];
    enum type type;
};

static size_t nb_elements;
static struct element elements[MAX_ELEMENTS] = {0};

#define type_name(e) ((e).type ? "G" : "M")

int cmp_elements(const void *a, const void *b) {
    struct element *lhs = (struct element *)a;
    struct element *rhs = (struct element *)b;
    int cmp_m = strncmp(lhs->material, rhs->material, N_CHARS);
    if (0 == cmp_m) {
        return rhs->type - lhs->type;
    }
    return cmp_m;
}

int find_element_id(struct element element) {
    for (size_t i = 0; i < nb_elements; ++i) {
        if (0 == cmp_elements(&elements[i], &element)) {
            return i;
        }
    }
    assert(false);
}

void print_elements(void) {
    printf("Elems:");
    for (size_t i = 0; i < nb_elements; ++i) {
        struct element *e = &elements[i];
        printf("  %ld:%s_%s", i, e->material, type_name(*e));
    }
    printf("\n");
}

/******************
 * Floors & State *
 ******************/

#define NIBBLE_BITS 4
#define NIBBLE_MASK 0x0f

struct state {
    uint16_t floors[4];
    uint64_t positions; // one nibble per element, allows at most 16 elements
};

int get_position(struct state *state, int element_id) {
    return state->positions>>(NIBBLE_BITS*element_id) & NIBBLE_MASK;
}

void set_position(struct state *state, int element_id, int floor_number) {
    uint16_t mask = ~ (1<<element_id);
    for (int i = 0; i < NB_FLOORS; ++i) {
        state->floors[i] &= mask;
    }
    state->floors[floor_number] |= 1<<element_id;

    int nibble_offset = 4*element_id;
    uint64_t element_mask = 0xf<<nibble_offset;
    state->positions &= ~element_mask;
    state->positions |= floor_number<<nibble_offset;
}

bool is_at_floor(struct state *state, int element_id, int floor_number) {
    return floor_number == get_position(state, element_id);
}

void print_floor(struct state *state, int floor_number) {
    printf("F%d ",floor_number+1);
    for (size_t i = 0; i < nb_elements; ++i) {
        printf("%s", is_at_floor(state, i, floor_number) ? "X": ".");
    }
    printf("\n");
}

void print_state(struct state state) {
    printf("   ");
    for (size_t i = 0; i < nb_elements; ++i) {
        printf("%ld", i);
    }
    printf("\n");
    for (int i = NB_FLOORS-1; i >= 0 ; --i) {
        print_floor(&state, i);
    }
    uint64_t floors_as_int = *(uint64_t*)state.floors;
    for (int i = NB_FLOORS - 1; i >= 0; --i) {
        printf("%04lx\n", 0xffff & floors_as_int>>(i*16)) ;
    }
    for (size_t i = 0; i<nb_elements; ++i) {
        struct element element = elements[i];
        printf("%s_%s:%d\n", element.material, type_name(element),
                get_position(&state, i));
    }
}

/******************
 * Solving (TODO) *
 ******************/

uint64_t solve_1(struct state state) {
    print_elements();
    print_state(state);
    return *(uint64_t*)state.floors;
}

/***********
 * Parsing *
 ***********/

struct element *parse_line(char *line) {
    char line_buff[MAX_LINE_LENGTH];
    strncpy(line_buff, line, MAX_LINE_LENGTH);
    assert('\0' == line_buff[MAX_LINE_LENGTH-1]);
    char **words = split(line_buff, " ,.");
    assert(words);
    struct element *result = NULL;

    // skip past "contains"
    size_t i = 0;
    char *word = words[i];
    while (0 != strcmp("contains", word)) {
        word = words[i++];
    }
    word = words[i++];
    // content
    if (0 == strcmp("nothing", word)) {
        goto end;
    }
    int word_position = 0;
    struct element e;
    size_t nb_words = da_size(words);
    for (;i < nb_words; ++i) {
        word = words[i];
        if (0 == strcmp("and", word)) {
            continue;
        }
        if (0 == strcmp("a", word)) {
            word_position = 0;
            continue;
        }
        if (word_position == 0) {
            strncpy(e.material, word, 4);
            e.material[4] = '\0';
        }
        else {
            e.type = ('g' == word[0]) ? GENERATOR_TYPE : MICROCHIP_TYPE;
            da_push(result, e);
        }
        ++word_position;
    }
end:
    da_free(words);
    return result;
}

void parse_input(char* lines[], struct element *elems_by_floor[]) {
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        char *line = lines[i];
        struct element *elements_at_floor = parse_line(line);
        elems_by_floor[i] = elements_at_floor;
    }
}

void init(char* lines[], struct state *state, struct element elements[], size_t *nb_elements) {
    // Parsing lines as floors
    struct element *elems_by_floor[NB_FLOORS];
    parse_input(lines, elems_by_floor);

    // Building an ordered list of elements
    *nb_elements = 0;
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        struct element *elements_at_floor = elems_by_floor[i];
        for (size_t j = 0; j < da_size(elements_at_floor); ++j) {
            elements[(*nb_elements)++] = elements_at_floor[j];
        }
    }
    assert(*nb_elements <= MAX_ELEMENTS);
    qsort(elements, *nb_elements, sizeof elements[0], cmp_elements);

    // Using the above to build a state
    *state = (struct state){0};
    for (size_t floor_number = 0; floor_number < NB_FLOORS; ++floor_number) {
        struct element *floor = elems_by_floor[floor_number];
        state->floors[floor_number] = 0;
        for (size_t j = 0; j < da_size(floor); ++j) {
            int element_id = find_element_id(floor[j]);
            set_position(state, element_id, floor_number);
        }
    }

    // free elements by floor arrays
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        da_free(elems_by_floor[i]);
    }
}

/*********
 * Tests *
 *********/

void test(void) {
    printf("Testing 11...\n");
    char *lines[] = {
        "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.",
        "The second floor contains a hydrogen generator.",
        "The third floor contains a lithium generator.",
        "The fourth floor contains nothing relevant.",
    };

    struct state state;
    init(lines, &state, elements, &nb_elements);
    assert(4 == nb_elements);

    assert(0 == strcmp("hydr", elements[0].material));
    assert(0 == strcmp("G", type_name(elements[0])));

    assert(0 == strcmp("hydr", elements[1].material));
    assert(0 == strcmp("M", type_name(elements[1])));

    assert(0 == strcmp("lith", elements[2].material));
    assert(0 == strcmp("G", type_name(elements[2])));

    assert(0 == strcmp("lith", elements[3].material));
    assert(0 == strcmp("M", type_name(elements[3])));

    assert(1 == get_position(&state, 0));
    assert(0 == get_position(&state, 1));
    assert(2 == get_position(&state, 2));
    assert(0 == get_position(&state, 3));

    for (int i = 0 ; i < MAX_ELEMENTS; ++i) {
        set_position(&state, i, 0);
    }
    assert(get_position(&state, 0) == 0);
    assert(state.floors[0] == 0x3ff);

    set_position(&state, 0, 1);
    assert(get_position(&state, 0) == 1);
    assert(state.floors[1] == 0x001);
    assert(state.floors[0] == 0x3fe);

    set_position(&state, 0, 3);
    assert(get_position(&state, 0) == 3);
    assert(state.floors[3] == 0x001);
    assert(state.floors[1] == 0x000);

    printf("[OK]\n");
}

/*
 * Le plan
 *
 * Pour pouvoir faire le graph des possibles, on veut pouvoir savoir si un
 * élément peut aller à l'étage n.
 *
 * L'étage "next" est soit l'étage n+1 soit l'étage n-1 ? Même étage possible ?
 *
 * Un microchip peut aller à l'étage "next" si, au choix :
 * - il y a son generator dans l'étage next
 * - il n'y a pas d'autre generator dans l'étage next
 *
 * Un generator peut aller à l'étage "next" si :
 * - son microchip n'est pas à l'étage prévious ou il n'y a pas d'autre
 *   generator à previous
 * - il n'y a pas de microchip incompatible seul à l'étage next
 *
 * L'ascenseur peut monter zéro, un ou deux éléments. Est-ce qu'on a besoin de
 * modéliser l'ascenseur ?
 *
 */

int main(int argc, char **argv) {
    if (NULL != getenv("AOC_TEST")) {
        test();
        return 0;
    }

    char *filename = (argc == 1) ? "input/11" : argv[1];
    char **lines = get_lines(filename);
    assert(NB_FLOORS == da_size(lines));

    struct state state;
    init(lines, &state, elements, &nb_elements);
    free_lines(lines);

    uint64_t result_1 = solve_1(state);
    printf("%016lx\n", result_1);
}
