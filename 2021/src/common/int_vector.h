#ifndef INT_VECTOR_H
#define INT_VECTOR_H

#include <stdlib.h>

#define V int_vector_t
typedef struct V* V;

V int_vector_alloc();
void int_vector_free(V* vp);
int int_vector_get(V v, size_t pos);
void int_vector_set(V v, size_t pos, int value);
void int_vector_push(V v, int value);

#undef V
#endif
