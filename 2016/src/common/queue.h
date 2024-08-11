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

struct queue *queue_init(struct arena *a, size_t capacity);
size_t queue_size(struct queue *self);
void queue_append(struct queue *self, void *value);
void *queue_remove(struct queue *self);

#endif
