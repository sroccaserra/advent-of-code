#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "vector.h"

void test_alloc_free() {
    vector_t v = vector_alloc();
    vector_free(&v);

    assert(NULL == v);
}

void test_push_get() {
    vector_t v = vector_alloc();
    char* val = "a";

    vector_push(v, val);
    char* result = vector_get(v, 0);

    assert(0 == strcmp("a", result));
    vector_free(&v);
}

int main() {
    test_alloc_free();
    test_push_get();
}
