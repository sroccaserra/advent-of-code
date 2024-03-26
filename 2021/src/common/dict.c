#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>

#include "dict.h"

/******************
 * Implementation *
 ******************/

#include "treap.h"

#define D dict_t
#define R (1.0*rand()/RAND_MAX)

D dict_alloc() {
    return (D)treap_alloc();
}

void dict_free(D* d) {
    treap_t t = (treap_t)*d;
    treap_free(&t);
    *d = NULL;
}

void dict_put(D d, char* key, void* value) {
    treap_insert((treap_t)d, key, value, R);
}

void* dict_at(D d, char* key) {
    return treap_search((treap_t)d, key);
}

bool dict_remove(D d, char* key) {
    return treap_remove((treap_t)d, key);
}

size_t dict_size(D d) {
    return treap_size((treap_t)d);
}

#undef D

