#ifndef DICT_H
#define DICT_H

#include <stdbool.h>

#define D dict_t
typedef struct D* D;

D dict_alloc();
void dict_free(D* d);

void dict_put(D d, char* key, void* value);
void* dict_at(D d, char* key);
bool dict_remove(D d, char* key);

#undef D
#endif
