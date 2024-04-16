#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "common/common.h"

#define NB_FLOORS 4

enum type {
    MICROCHIP,
    RTG,
};

typedef struct element_s {
    char material[5];
    enum type type;
} element_s;

typedef element_s* floor;

int solve_1(floor* floors) {
    for (int i = 0; i < NB_FLOORS; ++i) {
        floor floor = floors[i];
        printf("# floor %d\n", i+1);
        for(size_t j = 0; j < da_size(floor); ++j) {
            element_s* e = &floor[j];
            printf("%s %s\n", e->material, e->type == MICROCHIP ? "microchip" : "rtg");
        }
    }
    return 0;
}

element_s* parse_line(char* line) {
    char** words = split(line, " ,.");
    element_s* result = NULL;

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
    element_s e;
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
            e.type = ('g' == word[0]) ? RTG : MICROCHIP;
            da_push(result, e);
        }
        ++word_position;
    }
end:
    da_free(words);
    return result;
}

/*
The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.
*/


int main() {
    char** lines;
    int res = getlines("input/11", &lines);
    assert(0 == res);

    floor floors[NB_FLOORS];
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        floors[i] = NULL;
    }

    size_t nb_lines = da_size(lines);
    for (size_t i = 0; i < nb_lines; ++i) {
        char* line = lines[i];
        floors[i] = parse_line(line);
        free(line);
    }
    da_free(lines);

    solve_1(floors);

    for (size_t i = 0; i < NB_FLOORS; ++i) {
        da_free(floors[i]);
    }
}
