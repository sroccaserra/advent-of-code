#ifndef DYNARRAY_H
#define DYNARRAY_H

#include <stddef.h>
#include <stdlib.h>

typedef struct da_header_s {
    size_t size;
    size_t capacity;
} da_header_s;

#define da_header(a) ((da_header_s*)(a) - 1)
#define da_push(a, v) (a = da_grow(a, sizeof(*(a))), (a)[da_header(a)->size++] = (v))
#define da_free(a) ((void)(a ? free(da_header(a)) : (void)0), (a) = NULL)

size_t da_size(void* a);
void* da_grow(void* a, size_t elem_size);

#endif
