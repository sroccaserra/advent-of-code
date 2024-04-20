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

enum type {
    MICROCHIP,
    GENERATOR,
};

struct element {
    char material[N_CHARS+1];
    enum type type;
};

static size_t nb_elements;

int cmp_elements(const void* a, const void* b) {
    struct element* lhs = (struct element*)a;
    struct element* rhs = (struct element*)b;
    int cmp_m = strncmp(lhs->material, rhs->material, N_CHARS);
    if (0 == cmp_m) {
        return rhs->type - lhs->type;
    }
    return cmp_m;
}

void print_elements(struct element* elements) {
    printf("Elems:\t");
    bool is_first_time = true;
    for (size_t i = 0; i < nb_elements; ++i) {
        if (!is_first_time) {
            printf(", ");
        }
        struct element* e = &elements[i];
        printf("%ld:%s:%s", i, e->material, e->type == MICROCHIP ? "M" : "G");
        is_first_time = false;
    }
    printf("\n");
}

void print_floor(uint16_t floor) {
    char buffer[MAX_ELEMENTS+1];
    itoa(floor, buffer, 2);
    reverse(buffer);
    for (int j = strlen(buffer); j < MAX_ELEMENTS; ++j) {
        buffer[j] = '0';
    }
    buffer[nb_elements] = '\0';
    printf("%16s\n", buffer);
}

void print_floors(uint16_t* floors) {
    for (int i = NB_FLOORS-1; i >= 0 ; --i) {
        print_floor(floors[i]);
    }
}

uint64_t solve_1(struct element* elements, uint16_t* floors) {
    print_elements(elements);
    print_floors(floors);
    return *(uint64_t*)floors;
}

struct element* parse_line(char* line) {
    char** words = split(line, " ,.");
    struct element* result = NULL;

    // skip past "contains"
    size_t i = 0;
    char* word = words[i];
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
            e.type = ('g' == word[0]) ? GENERATOR : MICROCHIP;
            da_push(result, e);
        }
        ++word_position;
    }
end:
    da_free(words);
    return result;
}

int find_index_of(struct element* haystack, struct element needle) {
    for (size_t i = 0; i < nb_elements; ++i) {
        if (0 == cmp_elements(&haystack[i], &needle)) {
            return i;
        }
    }

    return -1;
}

uint16_t* build_floors(struct element* elements, struct element** elements_by_floor) {
    uint16_t* result = malloc(NB_FLOORS*sizeof(uint16_t));
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        struct element* floor = elements_by_floor[i];
        result[i] = 0;
        for (size_t j = 0; j < da_size(floor); ++j) {
            int index = find_index_of(elements, floor[j]);
            assert(-1 != index);
            result[i] |= 1<<index;
        }
    }
    return result;
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
int main(int argc, char** argv) {
    char* filename = (argc == 1) ? "input/11" : argv[1];
    char** lines = getlines(filename);

    size_t nb_lines = da_size(lines);
    assert(NB_FLOORS == nb_lines);

    struct element* elements = NULL;
    struct element* elems_by_floor[NB_FLOORS];
    for (size_t i = 0; i < nb_lines; ++i) {
        char* line = lines[i];
        struct element* elements_at_floor = parse_line(line);
        elems_by_floor[i] = elements_at_floor;
        for (size_t j = 0; j < da_size(elements_at_floor); ++j) {
            da_push(elements, elements_at_floor[j]);
        }
        free(line);
    }
    da_free(lines);

    nb_elements = da_size(elements);
    assert(nb_elements <= 16);
    qsort(elements, nb_elements, sizeof(struct element),cmp_elements);

    uint16_t* floors = build_floors(elements, elems_by_floor);
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        da_free(elems_by_floor[i]);
    }

    uint64_t result_1 = solve_1(elements, floors);
    printf("%lx\n", result_1);

    free(floors);
    da_free(elements);
}
