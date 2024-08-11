#ifndef QUEUE_H
#define QUEUE_H

#include <stddef.h>

#include "arena.h"

struct queue {
    int begin;
    int size;
    int capacity;
    void **data;
};

struct queue *queue_init(struct arena *a, size_t capacity) {
    struct queue *result = arena_push(a, sizeof(struct queue));

    result->begin = 0;
    result->size = 0;
    result->capacity = capacity;
    result->data = arena_push(a, capacity*sizeof(void *));

    return result;
}

size_t queue_size(struct queue *self) {
    return self->size;
}

void queue_append(struct queue *self, void *value) {
    assert(self->size < self->capacity);

    int index = (self->begin + self->size) % self->capacity;
    ++(self->size);
    self->data[index] = value;
}

void *queue_remove(struct queue *self) {
    assert(0 < self->size);

    void *result = self->data[self->begin];
    self->begin = (self->begin + 1)%self->capacity;
    --(self->size);
    return result;
}

#endif
