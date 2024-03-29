#include <stdlib.h>
#include <assert.h>

#include "int_vector.h"

#define V int_vector_t

struct V {
    int* data;
    size_t size;
    size_t max_size;
};

const size_t default_size = 8;

V int_vector_alloc() {
    int* data = malloc(sizeof(int[default_size]));
    assert(NULL != data);

    V result = malloc(sizeof(*result));
    result->data = data;
    result->size = 0;
    result->max_size = default_size;
    return result;
}

void int_vector_free(V* vp) {
    V v = *vp;
    assert(NULL != v);
    assert(NULL != v->data);

    free(v->data);
    v->data = NULL;
    v->size = 0;
    v->max_size = default_size;
    *vp = NULL;
}

static void int_vector_resize(V v, size_t new_max_size) {
    assert(NULL != v);
    assert(NULL != v->data);
    assert(v->max_size < new_max_size);

    int* data = realloc(v->data, sizeof(int[new_max_size]));
    assert(NULL != data);

    v->data = data;
    v->max_size = new_max_size;
}

int int_vector_get(V v, size_t pos) {
    assert(pos < v->size);
    return v->data[pos];
}

void int_vector_set(V v, size_t pos, int value) {
    assert(pos < v->size);
    v->data[pos] = value;
}

void int_vector_push(V v, int value) {
    size_t new_pos = v->size;
    if (v->max_size <= new_pos) {
        int_vector_resize(v, 2*v->max_size);
    }
    assert (new_pos < v->max_size);
    v->data[new_pos] =value;
    v->size += 1;
}

#undef V
