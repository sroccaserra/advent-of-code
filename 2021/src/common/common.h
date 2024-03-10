#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>

#include "PointerVector.h"

int getln(FILE* file, char** linep);

int getlines(char* filename, char*** lines, size_t* size) {
    FILE *file = fopen(filename, "r");
    if (NULL == file) {
        printf("Error: file not found.\n");
        return 1;
    }

    PointerVector vlines = createPointerVector();
    char* line;
    while(EOF != getln(file, &line)) {
        pushValue(&vlines, line);
    };
    fclose(file);

    *size = vlines.size;
    *lines = (char**)vlines.data;

    return 0;
}

/**
 * Definition of getln() function.
 *
 * We could use the POSIX getline() function, but it would
 * require to define _POSIX_C_SOURCE=200809L in our build chain,
 * which is fine but I think it's a little bit ugly.
 *
 * And by writing getln() I learn something.
 */

#define GETL_INIT_SIZE 8
#define GETL_GROW_BY 2

#define GETL_EXTRA_SPACE 2

int getln(FILE* file, char** linep) {
    char* array = malloc(GETL_INIT_SIZE*sizeof(char));
    if (array == NULL) {
        return -1;
    }

    int max = GETL_INIT_SIZE;
    int nchars = 0;
    int c;
    while ((c = fgetc(file)) != EOF && c != '\n') {
        if (nchars + GETL_EXTRA_SPACE >= max) {
            char* new_array = realloc(array, (GETL_GROW_BY*max)*sizeof(char));
            if (NULL == new_array) {
                fprintf(stderr, "Error: could not allocate mem for line.\n");
                return -1;
            }
            max *= GETL_GROW_BY;
            array = new_array;
        }
        array[nchars] = c;
        nchars++;
    }

    array[nchars] = '\0';
    *linep = array;

    if (c == EOF) {
        return -1;
    }

    return 0;
}

#endif
