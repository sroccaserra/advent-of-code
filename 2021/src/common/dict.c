#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "dict.h"

/******************
 * Implementation *
 ******************/

#include "treap.h"

#define D dict_t
#define R (1.0*rand()/RAND_MAX)

void fprint_entry(FILE* f, const void* key) {
    fprintf(f, "%s", (char*)key);
}

D str_dict_alloc() {
    return (D)treap_alloc((cmp_fn)strcmp, fprint_entry);
}

D dict_alloc(cmp_fn cmp, fprint_fn fpr) {
    return (D)treap_alloc(cmp, fpr);
}

void dict_free(D* dp) {
    treap_t t = (treap_t)*dp;
    treap_free(&t);
    *dp = NULL;
}

void dict_put(D d, void* key, void* value) {
    treap_insert((treap_t)d, key, value, R);
}

void* dict_at(D d, void* key) {
    return treap_search((treap_t)d, key);
}

bool dict_remove(D d, void* key) {
    return treap_remove((treap_t)d, key);
}

size_t dict_size(D d) {
    return treap_size((treap_t)d);
}

#undef D
