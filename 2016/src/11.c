#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "common/common.h"
#include "common/vector.h"

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
            printf("%s %s\n", e->material, e->type == MICROCHIP ? "microchip" : "rtg");
        }
    }
    return 0;
}

void scan_line(char* line, vector_t* floor) {
    char** words = NULL;
    size_t nb_words;
    split(line, " ,.", &words, &nb_words);

    // skip past "contains"
    size_t i = 0;
    char* word = words[i];
    while (0 != strcmp("contains", word)) {
        word = words[i++];
    }
    word = words[i++];
    // content
    if (0 == strcmp("nothing", word)) {
        return;
    }
    int word_position = 0;
    struct element* e;
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
            e = malloc(sizeof *e);
            strncpy(e->material, word, 4);
            e->material[4] = '\0';
        }
        else {
            e->type = ('g' == word[0]) ? RTG : MICROCHIP;
            vector_push(*floor, e);
        }
        ++word_position;
    }
    free(words);
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
        free(line);
    }
    free(lines);

    solve_1(floors);

    for (size_t i = 0; i < NB_FLOORS; ++i) {
        vector_t floor = floors[i];
        for (size_t j = 0; j < vector_size(floor); ++j) {
            struct element* e = vector_get(floor, j);
            free(e);
            vector_set(floor, j, NULL);
        }
        vector_free_all(&floor);
    }
}
