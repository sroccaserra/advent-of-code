#ifndef COMMON_H
#define COMMON_H

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

#include "dynarray.h"

#define assert_msg(val, msg) (val ? (void)0 : (perror(msg), assert(val)))

int getln(FILE* const file, char** const linep);

char** getlines(const char* const filename) {
    errno = 0;
    FILE* const file = fopen(filename, "r");
    assert_msg(file, filename);

    char** lines = NULL;
    char* line;
    while(EOF != getln(file, &line)) {
        da_push(lines, line);
    };
    fclose(file);

    return lines;
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

int getln(FILE* const file, char** const linep) {
    errno = 0;
    char* array = malloc(GETLN_INIT_SIZE*sizeof(char));
    assert_msg(array, "getln");

    int max = GETLN_INIT_SIZE;
    int nchars = 0;
    int c;
    while ((c = fgetc(file)) != EOF && c != '\n') {
        if (nchars + GETLN_EXTRA_SPACE >= max) {
            max *= GETLN_GROW_BY;
            errno = 0;
            char* new_array = realloc(array, max*sizeof(char));
            assert_msg(new_array, "getln");
            array = new_array;
        }
        array[nchars] = c;
        nchars++;
    }

    if (c == EOF && 0 == nchars) {
        free(array);
        return EOF;
    }

    array[nchars] = '\0';
    *linep = array;

    return (c == EOF) ? EOF : 0;
}

char** split(char* src, char* delim) {
    char** words = NULL;
    char* saveptr;
    char* word = strtok_r(src, delim, &saveptr);
    while (NULL != word) {
        da_push(words, word);
        word = strtok_r(NULL, delim, &saveptr);
    }
    return words;
}

/************/
/* From K&R */
/************/

void reverse(char* s) {
    int i, j;
    char c;

    for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

void itoa(long int n, char* s, int base) {
    int i, sign;

    if ((sign = n) < 0)  /* record sign */
        n = -n;          /* make n positive */
    i = 0;
    do {       /* generate digits in reverse order */
        s[i++] = n % base + '0';   /* get next digit */
    } while ((n /= base) > 0);     /* delete it */
    if (sign < 0) {
        s[i++] = '-';
    }
    s[i] = '\0';
    reverse(s);
}
#endif
