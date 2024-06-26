#ifndef DYNARRAY_H
#define DYNARRAY_H

#include <stddef.h>
#include <stdlib.h>

struct da_header {
    size_t size;
    size_t capacity;
};

#define da_header(a) ((struct da_header*)(a) - 1)
#define da_push(a, v) (a = da_grow(a, sizeof(*(a))), (a)[da_header(a)->size++] = (v))
#define da_free(a) ((void)(a ? free(da_header(a)) : (void)0), (a) = NULL)

size_t da_size(const void *const a);
void *da_grow(void *const a, const size_t elem_size);

#define da_free_items(a) do {                      \
        const size_t nb_items = da_size(a);        \
        for (size_t i = 0; i < nb_items; ++i) {    \
            free((a)[i]);                          \
            (a)[i] = 0;                            \
        }                                          \
    } while(0)

#endif
