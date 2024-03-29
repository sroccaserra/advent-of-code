#ifndef TREAP_H
#define TREAP_H

#include <stdbool.h>
#include <stdio.h>

/*************
 * Interface *
 *************/

#define T treap_t
typedef struct T* T;

typedef int (*cmp_fn)(const void* lhs, const void* rhs);
typedef void (*fprint_fn)(FILE* f, const void* entry);

T treap_alloc(cmp_fn cmp, fprint_fn fprint);
void treap_free(T* t);

void treap_insert(T t, void* key, void* value, double priority);
void* treap_search(T t, void* key);
bool treap_remove(T t, void* key);
size_t treap_size(T t);
void treap_print(T t);
void treap_fprint(FILE* f, T t);

#undef T
#endif
