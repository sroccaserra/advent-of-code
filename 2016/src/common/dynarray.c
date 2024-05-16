#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "dynarray.h"

#define MIN_CAPACITY 8

size_t da_size(const void *const a) {
    if (a == NULL) {
        return 0;
    }
    struct da_header *h = da_header(a);
    return h->size;
}

void *da_grow(void *const a, const size_t elem_size) {
    struct da_header *const header = a ? da_header(a) : NULL;
    if (a && (header->size < header->capacity)) {
        return a;
    }
    const size_t new_capacity = a ? 2*header->capacity : MIN_CAPACITY;
    const size_t next_size = new_capacity*elem_size + sizeof(struct da_header);
    struct da_header *const new_header = realloc(header, next_size);
    assert(new_header);
    if (NULL == a) {
        new_header->size = 0;
    }
    new_header->capacity = new_capacity;
    return (char*)new_header + sizeof(struct da_header);
}
