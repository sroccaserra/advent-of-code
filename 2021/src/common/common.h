#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <errno.h>

#include "PointerVector.h"

int getln(FILE* file, char** linep);

int getlines(char* filename, char*** linesp, size_t* size) {
    errno = 0;
    FILE *file = fopen(filename, "r");
    if (NULL == file) {
        perror(filename);
        return -1;
    }

    PointerVector* lines = createPointerVector();
    char* line;
    while(EOF != getln(file, &line)) {
        pushValue(lines, line);
    };
    fclose(file);

    *size = lines->size;
    *linesp = (char**)lines->data;
    freePointerVector(&lines);

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

#define GETLN_INIT_SIZE 8
#define GETLN_GROW_BY 2
#define GETLN_EXTRA_SPACE 1

int getln(FILE* file, char** linep) {
    errno = 0;
    char* array = malloc(GETLN_INIT_SIZE*sizeof(char));
    if (array == NULL) {
        perror("getln");
        return -1;
    }

    int max = GETLN_INIT_SIZE;
    int nchars = 0;
    int c;
    while ((c = fgetc(file)) != EOF && c != '\n') {
        if (nchars + GETLN_EXTRA_SPACE >= max) {
            max *= GETLN_GROW_BY;
            errno = 0;
            char* new_array = realloc(array, max*sizeof(char));
            if (NULL == new_array) {
                perror("getln");
                return -1;
            }
            array = new_array;
        }
        array[nchars] = c;
        nchars++;
    }

    array[nchars] = '\0';
    *linep = array;

    return (c == EOF) ? EOF : 0;
}

#endif
