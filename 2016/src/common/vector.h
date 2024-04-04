#ifndef VECTOR_H
#define VECTOR_H

#include <stdlib.h>

#define V vector_t
typedef struct V* V;

V vector_alloc();
void vector_free(V* v);

size_t vector_size(V v);
void vector_push(V v, void* value);
void* vector_get(V v, size_t pos);
void vector_set(V v, size_t pos, void* value);
void vector_clear(V v);
void* vector_array(V v);

#undef V
#endif
