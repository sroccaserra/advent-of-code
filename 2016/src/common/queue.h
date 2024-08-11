#ifndef QUEUE_H
#define QUEUE_H

#include <stdlib.h>

#include "arena.h"

struct queue {
    size_t size;
    size_t capacity;
    void *data;
};

struct queue *queue_init(struct arena *a, size_t capacity) {
    struct queue *result = arena_push(a, sizeof(struct queue));
    result->size = 0;
    result->capacity = capacity;
    result->data = arena_push(a, capacity);
    return result;
}

size_t queue_size(struct queue *self) {
    return self->size;
}

void queue_append(struct queue *self, void *value) {
    self->data = value;
    ++(self->size);
}

void *queue_remove(struct queue *self) {
    --(self->size);
    return self->data;
}

#endif
