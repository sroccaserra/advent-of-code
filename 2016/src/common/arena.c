#include "arena.h"

#include <assert.h>
#include <stdlib.h>

struct arena *arena_init(size_t capacity) {
    assert(capacity);
    char *mem = malloc(capacity);
    assert(mem);
    struct arena *result = malloc(sizeof(struct arena));
    assert(result);
    *result = (struct arena){.mem = mem, .capacity = capacity};
    return result;
}

void arena_discard(struct arena *a) {
    free(a->mem);
    *a = (struct arena){0};
    free(a);
}

void *arena_push(struct arena *a, size_t size) {
    assert(a->used + size <= a->capacity);

    void *result = arena_pointer(a);
    a->used += size;

    return result;
}

void arena_pop(struct arena *a, size_t size) {
    assert(size <= a->used);
    a->used -= size;
}

size_t arena_used(struct arena *a) {
    return a->used;
}
