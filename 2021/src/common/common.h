#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdio.h>

#include "PointerVector.h"

int getlines(char* filename, char*** lines, size_t* size) {
    FILE *file = fopen(filename, "r");
    if (NULL == file) {
        printf("Error: file not found.\n");
        return 1;
    }

    PointerVector vlines = createPointerVector();
    char* line = NULL;
    size_t len = 0;
    while(EOF != getline(&line, &len, file)) {
        pushValue(&vlines, line);
        line = NULL;
        len = 0;
    };
    fclose(file);

    *size = vlines.size;
    *lines = (char**)vlines.data;

    return 0;
}

#endif // __COMMON_H__
