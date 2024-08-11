#ifndef ARENA_H
#define ARENA_H

#include <assert.h>
#include <stdlib.h>

struct arena {
    char *mem;
    size_t used;
    size_t size;
};

struct arena arena_init(size_t size);
void arena_discard(struct arena *a);

void *arena_push(struct arena *a, size_t size);
void arena_pop(struct arena *a, size_t size);
size_t arena_used(struct arena *a);

#endif
