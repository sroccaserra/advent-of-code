#ifndef ASTRING_H
#define ASTRING_H

#include <stdbool.h>
#include <string.h>

#include "arena.h"

// "astring" is for "arena string". "string" would be good, but the header file
// "string.h" would be confusing, "astring.h" is not.
//
// Conventions
// "cstr" is a usual null-terminated C string.
// "s" stands for a "struct astring"
// "a" stands for "arena"
// "ln" is for "length"

struct astring {
    int size;
    char *items;
};

struct astring *astring_init(struct arena *a, char *cstr) {
    struct astring *result = arena_push(a, sizeof(struct astring));
    result->size = strlen(cstr);
    result->items = cstr;
    return result;
}

void astring_set_cstr(struct astring *self, char *cstr) {
    self->size = strlen(cstr);
    self->items = cstr;
}

void astring_set_cstr_ln(struct astring *self, char *cstr, int size) {
    self->size = size;
    self->items = cstr;
}

bool astring_is_same(struct astring *self, char *cstr) {
    return 0 == strncmp(self->items, cstr, self->size);
}

struct astring_list {
    int size;
    struct astring *items;
};

struct astring_list* astring_split(struct arena *a, char *cstr, char *sep) {
    struct astring_list *result = arena_push(a, sizeof(struct astring_list));
    *result = (struct astring_list){0};

    char *cursor = cstr+strspn(cstr, sep);
    if ('\0' == *cursor) {
        return result;
    }

    result->items = arena_pointer(a);
    int i = 0;
    while ('\0' != *cursor) {
        int size = strcspn(cursor, sep);
        arena_push(a, sizeof(struct astring));
        astring_set_cstr_ln(&result->items[i++], cursor, size);
        ++result->size;
        cursor += size;
        cursor += strspn(cursor, sep);
    }
    return result;
}

#endif
