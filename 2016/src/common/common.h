#ifndef COMMON_H
#define COMMON_H

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>

#include "dynarray.h"

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

#define print(fmt, ...) printf(fmt"\n", __VA_ARGS__)

#endif
