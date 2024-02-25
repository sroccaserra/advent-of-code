#ifndef __POINTER_VECTOR_H__
#define __POINTER_VECTOR_H__

#include <stdlib.h>
#include <assert.h>

typedef struct {
    size_t size;
    size_t max_size;
    void** data;
} PointerVector;

const size_t pv_default_size = 8;

PointerVector createPointerVector() {
    void** data = malloc(sizeof(void*[pv_default_size]));
    assert(NULL != data);
    return (PointerVector){.size = 0, .max_size = pv_default_size,.data = data};
}

void deletePointerVector(PointerVector* v) {
    assert(NULL != v);
    assert(NULL != v->data);

    free(v->data);
    v->data = NULL;
    v->size = 0;
    v->max_size = pv_default_size;
}

void resizePointerVector(PointerVector* v, size_t new_max_size) {
    assert(NULL != v);
    assert(NULL != v->data);
    assert(v->max_size < new_max_size);

    void** data = realloc(v->data, sizeof(void*[new_max_size]));
    assert(NULL != data);

    v->data = data;
    v->max_size = new_max_size;
}

void* getValue(PointerVector* v, size_t pos) {
    assert(pos < v->size);
    return v->data[pos];
}

void setValue(PointerVector* v, size_t pos, void* value) {
    assert(pos < v->size);
    v->data[pos] = value;
}

void pushValue(PointerVector* v, void* value) {
    size_t new_pos = v->size;
    if (v->max_size <= new_pos) {
        resizePointerVector(v, 2*v->max_size);
    }
    assert (new_pos < v->max_size);
    v->data[new_pos] =value;
    v->size += 1;
}

#endif // __POINTER_VECTOR_H__
