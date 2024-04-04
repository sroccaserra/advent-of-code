#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "common/common.h"

#define NB_FLOORS 4

enum type {
    MICROCHIP,
    RTG,
};

struct element {
    char material[5];
    enum type type;
};

int solve_1(vector_t* floors) {
    for (int i = 0; i < NB_FLOORS; ++i) {
        vector_t floor = floors[i];
        printf("# floor %d\n", i+1);
        for(size_t j = 0; j < vector_size(floor); ++j) {
            struct element* e = vector_get(floor, j);
            printf("%s %s\n", e->material, e->type == MICROCHIP ? "microchip" : "rpg");
        }
    }
    return 0;
}

void scan_line(char* line, vector_t* floor) {
    char* res = strtok(line, " ");
    // skip to content
    do {
        res = strtok(NULL, " ");
    } while (0 != strcmp("contains", res));
    res = strtok(NULL, " ");
    int word_position = 0;
    if (0 == strcmp("nothing", res)) {
        return;
    }
    // content
    struct element* e;
    while (NULL != res)
    {
        if (res[0] == 'a') {
            if (res[1] == '\0') {
                word_position = 0;
                e = malloc(sizeof *e);
            }
            goto next;
        }
        if (word_position == 0) {
            strncpy(e->material, res, 4);
            e->material[4] = '\0';
        }
        else {
            e->type = ('g' == res[0]) ? RTG : MICROCHIP;
            vector_push(*floor, e);
        }
        ++word_position;
next:
        res = strtok(NULL, "., ");
    }
}

/*
The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.
*/


int main() {
    size_t nb_lines;
    char** lines;
    int res = getlines("input/11", &lines, &nb_lines);
    assert(0 == res);

    vector_t floors[NB_FLOORS];
    for (size_t i = 0; i < NB_FLOORS; ++i) {
        floors[i] = vector_alloc();
    }

    for (size_t i = 0; i < nb_lines; ++i) {
        char* line = lines[i];
        scan_line(line, &floors[i]);
    }

    solve_1(floors);

    for (size_t i = 0; i < NB_FLOORS; ++i) {
        vector_free(&floors[i]);
    }
}
