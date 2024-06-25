#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "common/common.h"
#include "common/dynarray.h"
#include "common/testing.h"

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
    if (cmp_m) {
        return cmp_m;
    }
    return rhs->type - lhs->type;
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
#define floors_as_uint64(floors) (*(uint64_t *)(floors))

struct state {
    uint16_t floors[4];
    uint64_t positions; // one nibble per element, allows at most 16 elements
};

void init_state(struct state *state) {
    state->floors[0] = 0x3ff; // All ten possible elements on the first floor
    state->floors[1] = 0;
    state->floors[2] = 0;
    state->floors[3] = 0;
    state->positions = 0;
}

/*
 * Two implementations here, by floors and positions.
 * TODO: choose one.
 */

static int get_position_from_positions(uint64_t positions, int element_id) {
    return positions>>(NIBBLE_BITS*element_id) & NIBBLE_MASK;
}

static int get_position_from_floors(uint16_t floors[], int element_id) {
    uint16_t floor_mask = 1<<element_id;
    int result = -1;
    for (int i = 0; i < NB_FLOORS; ++i) {
        if (floors[i] & floor_mask) {
            assert(result == -1);
            result = i;
        }
    }
    return result;
}

static void set_position_in_positions(uint64_t *positions, int element_id, uint64_t floor_number) {
    int nibble_offset = 4*element_id;
    uint64_t element_mask = 0xfl<<nibble_offset;
    *positions &= ~element_mask;
    *positions |= ((uint64_t)floor_number)<<nibble_offset;
}

static void set_position_in_floors(uint16_t floors[], int element_id, int floor_number) {
    uint16_t floor_mask = 1<<element_id;
    for (int i = 0; i < NB_FLOORS; ++i) {
        floors[i] &= ~floor_mask;
    }
    floors[floor_number] |= floor_mask;
}

/*
 * Public interface
 */

int get_position(struct state *state, int element_id) {
    int result_from_positions = get_position_from_positions(state->positions, element_id);
    int result_from_floors = get_position_from_floors(state->floors, element_id);
    assert_equals(result_from_positions, result_from_floors); // check implems coherence
    return result_from_positions;
}

void set_position(struct state *state, int element_id, int floor_number) {
    set_position_in_positions(&state->positions, element_id, floor_number);
    set_position_in_floors(state->floors, element_id, floor_number);
}


bool state_equals(struct state *lhs, struct state *rhs) {
    return 0 == memcmp(lhs, rhs, sizeof(struct state));
}

void init_from_positions(struct state *state, uint64_t positions) {
    init_state(state);
    for (size_t i = 0; i < MAX_ELEMENTS; ++i) {
        int pos = get_position_from_positions(positions, i);
        set_position(state, i, pos);
    }
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
    uint64_t floors_value = floors_as_uint64(state.floors);
    for (int i = NB_FLOORS - 1; i >= 0; --i) {
        printf("%04lx\n", 0xffff & floors_value>>(i*16)) ;
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

/*
 * La spec
 *
 * Within the radiation-shielded part of the facility (in which it's safe to
 * have these pre-assembly RTGs), there is an elevator that can move between
 * the four floors. Its capacity rating means it can carry at most yourself and
 * two RTGs or microchips in any combination. (They're rigged to some heavy
 * diagnostic equipment - the assembling machine will detach it for you.) As a
 * security measure, the elevator will only function if it contains at least
 * one RTG or microchip. The elevator always stops on each floor to recharge,
 * and this takes long enough that the items within it and the items on that
 * floor can irradiate each other.  (You can prevent this if a Microchip and
 * its Generator end up on the same floor in this way, as they can be connected
 * while the elevator is recharging.)
 */

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

uint64_t solve_1(struct state state) {
    print_elements();
    print_state(state);
    return floors_as_uint64(state.floors);
}

/***********
 * Parsing *
 ***********/

struct element *parse_line(char *line) {
    char line_buff[MAX_LINE_LENGTH];
    strncpy(line_buff, line, MAX_LINE_LENGTH);
    assert('\0' == line_buff[MAX_LINE_LENGTH-1]);
    char **words = split_da(line_buff, " ,.");
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

void parse_elems_by_floor(char* lines[], struct element *elems_by_floor[]) {
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        char *line = lines[i];
        struct element *elements_at_floor = parse_line(line);
        elems_by_floor[i] = elements_at_floor;
    }
}

void build_ordered_list_of_elements(struct element *elems_by_floor[], struct element elements[], size_t *nb_elements) {
    *nb_elements = 0;
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        struct element *elements_at_floor = elems_by_floor[i];
        for (size_t j = 0; j < da_size(elements_at_floor); ++j) {
            elements[(*nb_elements)++] = elements_at_floor[j];
        }
    }
    assert(*nb_elements <= MAX_ELEMENTS);
    qsort(elements, *nb_elements, sizeof elements[0], cmp_elements);
}

void build_state(struct element *elems_by_floor[], struct state *state) {
    init_state(state);
    for (size_t floor_number = 0; floor_number < NB_FLOORS; ++floor_number) {
        struct element *floor = elems_by_floor[floor_number];
        for (size_t j = 0; j < da_size(floor); ++j) {
            int element_id = find_element_id(floor[j]);
            set_position(state, element_id, floor_number);
        }
    }
}

void init_from_lines(char* lines[], struct state *state, struct element elements[], size_t *nb_elements) {
    struct element *elems_by_floor[NB_FLOORS];
    parse_elems_by_floor(lines, elems_by_floor);

    build_ordered_list_of_elements(elems_by_floor, elements, nb_elements);
    build_state(elems_by_floor, state);

    for (size_t i = 0; i < NB_FLOORS; ++i) {
        da_free(elems_by_floor[i]);
    }
}

/***********
 * Testing *
 ***********/

void test_shifts_on_uint64_t() {
    uint64_t vals[] = {
        1l<<(4*0), 1l<<(4*1), 1l<<(4*2), 1l<<(4*3), 1l<<(4*4),
        1l<<(4*5), 1l<<(4*6), 1l<<(4*7), 1l<<(4*8), 1l<<(4*9),
    };
    int nb_vals = sizeof(vals)/sizeof(vals[0]);

    for(int i = 0; i < nb_vals; ++i) {
        int element_id = i;
        int floor_number = 1;
        uint64_t positions = 0;

        int nibble_offset = 4*element_id;
        uint64_t element_mask = 0xfl<<nibble_offset;
        positions &= ~element_mask;
        positions |= ((uint64_t)floor_number)<<nibble_offset;

        assert_equals(vals[i], positions);
    }
}

#define TEST_LINES {                                                                                    \
        "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.", \
        "The second floor contains a hydrogen generator.",                                              \
        "The third floor contains a lithium generator.",                                                \
        "The fourth floor contains nothing relevant.",                                                  \
    }

void test_elements_are_parsed_and_assigned() {
    char *lines[] = TEST_LINES;
    struct state state;

    init_from_lines(lines, &state, elements, &nb_elements);

    assert_equals(4, nb_elements);
    assert_equals("hydr", elements[0].material);
    assert_equals("G", type_name(elements[0]));
    assert_equals("hydr", elements[1].material);
    assert_equals("M", type_name(elements[1]));
    assert_equals("lith", elements[2].material);
    assert_equals("G", type_name(elements[2]));
    assert_equals("lith", elements[3].material);
    assert_equals("M", type_name(elements[3]));
}

void test_element_positions_are_set() {
    char *lines[] = TEST_LINES;
    struct state state;

    init_from_lines(lines, &state, elements, &nb_elements);

    assert_equals(1, get_position(&state, 0));
    assert_equals(0, get_position(&state, 1));
    assert_equals(2, get_position(&state, 2));
    assert_equals(0, get_position(&state, 3));

    // The rest are set to floor 0
    for (int i = 4; i < MAX_ELEMENTS; ++i) {
        assert_equals(0, get_position(&state, i));
    }
}

void test_element_positions_can_be_updated() {
    struct state state;
    init_state(&state);

    assert_equals(0x03ff, state.floors[0]);
    assert_equals(0x0000, state.floors[1]);
    assert_equals(0x0000, state.floors[2]);
    assert_equals(0x0000, state.floors[3]);

    set_position(&state, 0, 1);

    assert_equals(1, get_position(&state, 0));
    assert_equals(0x03fe, state.floors[0]);
    assert_equals(0x0001, state.floors[1]);
    assert_equals(0x0000, state.floors[2]);
    assert_equals(0x0000, state.floors[3]);

    set_position(&state, 0, 3);

    assert_equals(3, get_position(&state, 0));
    assert_equals(0x03fe, state.floors[0]);
    assert_equals(0x0000, state.floors[1]);
    assert_equals(0x0000, state.floors[2]);
    assert_equals(0x0001, state.floors[3]);
}


void test_a_state_is_equal_to_itself() {
    struct state state;
    init_state(&state);
    assert(state_equals(&state, &state));
}

void test_init_from_positions() {
    struct state state = {0};

    init_from_positions(&state, 0x00);
    assert_equals(0, get_position(&state, 0));
    assert_equals(0, get_position(&state, 1));
    for (int i = 2; i < MAX_ELEMENTS; ++i) {
        assert_equals(0, get_position(&state, i));
    }

    init_from_positions(&state, 0x11);
    assert_equals(1, get_position(&state, 0));
    assert_equals(1, get_position(&state, 1));
    for (int i = 2; i< MAX_ELEMENTS; ++i) {
        assert_equals(0, get_position(&state, i));
    }

    init_from_positions(&state, 0x1111111111);
    for (int i = 0; i< MAX_ELEMENTS; ++i) {
        assert_equals(1, get_position(&state, i));
    }
}

void test_init_from_positions_and_from_lines() {
    char *lines[] = {
        "The first floor contains a hydr microchip and a hydr generator.",
        "The second floor contains nothing relevant.",
        "The third floor contains nothing relevant.",
        "The fourth floor contains nothing relevant.",
    };
    struct state from_lines;
    struct state from_positions;

    init_from_lines(lines, &from_lines, elements, &nb_elements);
    init_from_positions(&from_positions, 0x00);

    assert(state_equals(&from_positions, &from_lines));
}

void test(void) {
    TEST_START("11");

    test_shifts_on_uint64_t();
    test_elements_are_parsed_and_assigned();
    test_element_positions_are_set();
    test_element_positions_can_be_updated();
    test_init_from_positions();
    test_init_from_positions_and_from_lines();

    TEST_END;
}

/***********
 * Running *
 ***********/

int main(int argc, char **argv) {
    if (NULL != getenv("AOC_TEST")) {
        test();
        return 0;
    }

    char *filename = (argc == 1) ? "input/11" : argv[1];
    char **lines_da = get_lines_da(filename);
    assert(NB_FLOORS == da_size(lines_da));

    struct state state;
    init_from_lines(lines_da, &state, elements, &nb_elements);
    free_lines_da(lines_da);

    uint64_t result_1 = solve_1(state);
    printf("%016lx\n", result_1);
}
