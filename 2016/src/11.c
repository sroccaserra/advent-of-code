#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "common/common.h"
#include "common/dynarray.h"

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
    state->positions |= floor_number<<nibble_offset;
}

bool is_at_floor(struct state *state, int element_id, int floor_number) {
    return floor_number == get_position(state, element_id);
}

struct state build_state(struct element **elements_by_floor) {
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        struct element *elements_at_floor = elements_by_floor[i];
        for (size_t j = 0; j < da_size(elements_at_floor); ++j) {
            elements[nb_elements++] = elements_at_floor[j];
        }
    }
    qsort(elements, nb_elements, sizeof elements[0], cmp_elements);

    struct state result = {0};
    for (size_t floor_number = 0; floor_number < NB_FLOORS; ++floor_number) {
        struct element *floor = elements_by_floor[floor_number];
        result.floors[floor_number] = 0;
        for (size_t j = 0; j < da_size(floor); ++j) {
            int element_id = find_element_id(floor[j]);
            set_position(&result, element_id, floor_number);
        }
    }
    return result;
}

uint16_t *build_floors(struct element **elements_by_floor) {
    uint16_t *result = malloc(NB_FLOORS*sizeof(uint16_t));
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        struct element *floor = elements_by_floor[i];
        result[i] = 0;
        for (size_t j = 0; j < da_size(floor); ++j) {
            int element_id = find_element_id(floor[j]);
            result[i] |= 1<<element_id;
        }
    }
    return result;
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

/*************************
 * Parsing & entry point *
 *************************/

struct element *parse_line(char *line) {
    char **words = split(line, " ,.");
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

/*********
 * Tests *
 *********/

void test(void) {
    struct state state = {0};
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
}

void parse_input(char* lines[], struct element *elems_by_floor[]) {
    nb_elements = 0;
    size_t nb_lines = da_size(lines);
    for (size_t i = 0; i < nb_lines; ++i) {
        char *line = lines[i];
        struct element *elements_at_floor = parse_line(line);
        elems_by_floor[i] = elements_at_floor;
    }
    assert(nb_elements <= MAX_ELEMENTS);
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
    char *filename = (argc == 1) ? "input/11" : argv[1];
    char **lines = getlines(filename);

    size_t nb_lines = da_size(lines);
    assert(NB_FLOORS == nb_lines);

    struct element *elems_by_floor[NB_FLOORS];
    parse_input(lines, elems_by_floor);
    for (size_t i = 0; i < nb_lines; ++i) {
        free(lines[i]);
    }
    da_free(lines);

    struct state state = build_state(elems_by_floor);

    for (size_t i = 0; i < NB_FLOORS; ++i) {
        da_free(elems_by_floor[i]);
    }

    if (NULL != getenv("TEST")) {
        printf("Testing 11...");
        test();
        printf(" [OK]\n");
    } else {
        uint64_t result_1 = solve_1(state);
        printf("%016lx\n", result_1);
    }
}
