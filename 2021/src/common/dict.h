#ifndef DICT_H
#define DICT_H

#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>

#define D dict_t
typedef struct D* D;

typedef int (*cmp_fn)(const void* lkey, const void* rkey);
typedef void (*fprint_fn)(FILE* f, const void* lkey);

D str_dict_alloc();
D dict_alloc(cmp_fn, fprint_fn);
void dict_free(D* dp);

void dict_put(D d, void* key, void* value);
void* dict_at(D d, void* key);
bool dict_remove(D d, void* key);
size_t dict_size(D d);

#undef D
#endif
