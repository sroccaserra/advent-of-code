#ifndef COMMON_H
#define COMMON_H

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

#include "dynarray.h"

#define assert_msg(val, msg) (val ? (void)0 : (perror(msg), assert(val)))

int get_line(FILE *const file, char **const linep);

char **get_lines_da(const char *const filename) {
    errno = 0;
    FILE *const file = fopen(filename, "r");
    assert_msg(file, filename);

    char **lines = NULL;
    char *line;
    while(EOF != get_line(file, &line)) {
        da_push(lines, line);
    };
    fclose(file);

    return lines;
}

void free_lines_da(char *lines[]) {
    size_t nb_lines = da_size(lines);
    for (size_t i = 0; i < nb_lines; ++i) {
        free(lines[i]);
    }
    da_free(lines);
}

/**
 * Definition of getline() function.
 *
 * We could use the POSIX getline() function, but it would
 * require to define _POSIX_C_SOURCE=200809L in our build chain,
 * which is fine but I think it's a little bit ugly.
 *
 * And by writing getln() I learn something. See also: K&R getline()
 */

#define GETLN_MIN_CAP 8
#define GETLN_EXTRA_SPACE 1

int get_line(FILE *const file, char **const linep) {
    errno = 0;
    char* array = malloc(GETLN_MIN_CAP*sizeof(char));
    assert_msg(array, "getln");

    int c, size, capacity;
    for (size = 0, capacity = GETLN_MIN_CAP; (c = fgetc(file)) != EOF && c != '\n'; ++size) {
        if (capacity <= size + GETLN_EXTRA_SPACE) {
            capacity *= 2;
            errno = 0;
            char *new_array = realloc(array, capacity*sizeof(char));
            assert_msg(new_array, __func__);
            array = new_array;
        }
        array[size] = c;
    }

    if (EOF == c && 0 == size) {
        free(array);
        return EOF;
    }

    array[size] = '\0';
    *linep = array;

    return (c == EOF) ? EOF : 0;
}

/*
 * Does not work on string literals because of `strtok_r()` tries
 * to mutate src. Copy src to a mutable `char *` before splitting
 * if needed.
 */
char **split_da(char *src, const char *delim) {
    char **words = 0;
    char *saveptr = NULL;
    char *word = strtok_r(src, delim, &saveptr);
    while (NULL != word) {
        da_push(words, word);
        word = strtok_r(NULL, delim, &saveptr);
    }
    return words;
}

/************/
/* From K&R */
/************/

void reverse(char *s) {
    for (int i = 0, j = strlen(s)-1; i<j; i++, j--) {
        char c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

void itoa(long int n, char *s, int base) {
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
