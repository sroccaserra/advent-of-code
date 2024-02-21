#include <stdlib.h>
#include <assert.h>

typedef struct {
    int* data;
    size_t size;
    size_t max_size;
} IntVector;

const size_t default_size = 8;

IntVector createIntVector() {
    int* data = (int*)malloc(sizeof(int[default_size]));
    assert(NULL != data);
    return (IntVector){.data = data, .size = 0, .max_size = default_size};
}

void deleteIntVector(IntVector* v) {
    assert(NULL != v);
    assert(NULL != v->data);

    free(v->data);
    v->data = NULL;
    v->size = 0;
    v->max_size = default_size;
}

void resizeIntVector(IntVector* v, size_t new_max_size) {
    assert(NULL != v);
    assert(NULL != v->data);
    assert(v->max_size < new_max_size);

    int* data = (int*)realloc(v->data, sizeof(int[new_max_size]));
    assert(NULL != data);

    v->data = data;
    v->max_size = new_max_size;
}

int getInt(IntVector* v, size_t pos) {
    assert(pos < v->size);
    return v->data[pos];
}

void setInt(IntVector* v, size_t pos, int value) {
    assert(pos < v->size);
    v->data[pos] = value;
}

void pushInt(IntVector* v, int value) {
    size_t new_pos = v->size;
    if (v->max_size <= new_pos) {
        resizeIntVector(v, 2*v->max_size);
    }
    assert (new_pos < v->max_size);
    v->data[new_pos] =value;
    v->size += 1;
}
