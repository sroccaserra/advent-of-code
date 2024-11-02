#ifndef TEXT_H
#define TEXT_H

#include <errno.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>

#include "arena.h"

/*********
 * Slurp *
 *********/

#define check_errno(str) do { \
        if(errno) {           \
            perror(str);      \
            exit(1);          \
        }                     \
    } while (0)

long slurp(struct arena *a, FILE *file, char **ptext) {
    assert(file);
    long size = 0;
    int chunk_size = 256;
    char *start = arena_top(a);
    char *buffer = arena_push(a, chunk_size);
    char *buffer_pos = buffer;
    int read_size = 0;

    errno = 0;
    while (0 != (read_size = fread(buffer_pos, 1, chunk_size, file))) {
        check_errno(NULL);
        size += read_size;
        buffer_pos += read_size;
        arena_push(a, chunk_size);
    }

    fclose(file);
    buffer[size] = '\0';
    ptrdiff_t excess = ((char *)arena_top(a) - start) - (size + 1);
    arena_pop(a, excess);

    *ptext = buffer;
    return size;
}

long slurp_filename(struct arena *a, char *filename, char **ptext) {
    errno = 0;
    FILE *file = fopen(filename, "r");
    check_errno(filename);
    assert(file);
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    rewind(file);

    char *buffer = arena_push(a, size + 1);
    errno = 0;
    fread(buffer, size, 1, file);
    check_errno(NULL);
    fclose(file);
    buffer[size] = '\0';

    *ptext = buffer;
    return size;
}

/********************************************************
 * Split                                                *
 * Note: this function is destructive, like strtok_r(). *
 ********************************************************/

int split(struct arena *a, char *text, const char *sep, char **items[]) {
    assert(text);
    int nb_items = 0;
    int capacity = 1;
    size_t item_size = sizeof(items[0]);

    char *pos = text;
    pos += strspn(pos, sep);
    if ('\0' == *pos) {
        *items = NULL;
        return nb_items;
    }

    *items = arena_push(a, item_size*capacity);

    while (1) {
        if (capacity <= nb_items) {
            arena_push(a, item_size*capacity);
            capacity += capacity;
        }
        (*items)[nb_items++] = pos;
        char *found = strpbrk(pos, sep);
        if (found) {
            char *first = found;
            pos = found + strspn(found, sep);
            *first = '\0';
            if ('\0' == *pos) {
                break;
            }
        } else {
            break;
        }
    }
    int excess = (capacity - nb_items)*item_size;
    arena_pop(a, excess);

    return nb_items;
}

/********************************************************
 * Split Lines                                          *
 * Note: this function is destructive, like strtok_r(). *
 ********************************************************/

int split_lines(struct arena *a, char *text, char **lines[]) {
    return split(a, text, "\n", lines);
}

/*************
 * Get lines *
 *************/

long get_lines(struct arena *a, char *filename, char **lines[]) {
    char *text = NULL;
    slurp_filename(a, filename, &text);
    assert(text);
    long nb_lines = split_lines(a, text, lines);
    assert(lines);
    return nb_lines;
}

#endif
