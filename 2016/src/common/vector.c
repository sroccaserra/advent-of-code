#include <stdlib.h>
#include <assert.h>

#include "vector.h"

#define V vector_t

struct V {
    size_t size;
    size_t max_size;
    void** data;
};

const size_t pv_default_size = 8;

V vector_alloc() {
    void** data = malloc(sizeof(void*[pv_default_size]));
    assert(NULL != data);

    V result = malloc(sizeof(*result));
    result->size = 0;
    result->max_size = pv_default_size;
    result->data = data;
    return result;
}

/*
 * Does not free the data part, as PointerVector is useful to
 * assign a C array (the data part).
 */
void vector_free(V* v) {
    assert(*v);
    free(*v);
    *v = NULL;
}

size_t vector_size(V v) {
    return v->size;
}

void* vector_array(V v) {
    return v->data;
}

void vector_clear(V v) {
    assert(NULL != v);
    assert(NULL != v->data);

    free(v->data);
    v->data = NULL;
    v->size = 0;
    v->max_size = pv_default_size;
}

void* vector_get(V v, size_t pos) {
    assert(pos < v->size);
    return v->data[pos];
}

void vector_set(V v, size_t pos, void* value) {
    assert(pos < v->size);
    v->data[pos] = value;
}

static void vector_resize(V v, size_t new_max_size) {
    assert(NULL != v);
    assert(NULL != v->data);
    assert(v->max_size < new_max_size);

    void** data = realloc(v->data, sizeof(void*[new_max_size]));
    assert(NULL != data);

    v->data = data;
    v->max_size = new_max_size;
}

void vector_push(V v, void* value) {
    size_t new_pos = v->size;
    if (v->max_size <= new_pos) {
        vector_resize(v, 2*v->max_size);
    }
    assert (new_pos < v->max_size);
    v->data[new_pos] =value;
    v->size += 1;
}

#undef V
