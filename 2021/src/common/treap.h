#ifndef TREAP_H
#define TREAP_H

#include <stdbool.h>
#include <stdio.h>

/*************
 * Interface *
 *************/

#define T treap_t
typedef struct T* T;

T treap_alloc();
void treap_free(T* t);

void treap_insert(T t, char* key, void* value, double priority);
void* treap_search(T t, char* key);
bool treap_remove(T t, char* key);
size_t treap_size(T t);
void tfprint(FILE* f, T t);
void tprint(T t);

#undef T
#endif
