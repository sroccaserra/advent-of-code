#ifndef QUEUE_H
#define QUEUE_H

#include <stdlib.h>

#include "arena.h"

struct queue {
    int begin;
    int end;
    size_t capacity;
    void **data;
};

struct queue *queue_init(struct arena *a, size_t capacity) {
    struct queue *result = arena_push(a, sizeof(struct queue));

    result->begin = 0;
    result->end = 0;
    result->capacity = capacity;
    result->data = arena_push(a, capacity*sizeof(void *));

    return result;
}

size_t queue_size(struct queue *self) {
    return self->end - self->begin;
}

void queue_append(struct queue *self, void *value) {
    self->data[self->end++] = value;
}

void *queue_remove(struct queue *self) {
    return self->data[self->begin++];
}

#endif
