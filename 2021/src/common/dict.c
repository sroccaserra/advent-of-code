#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>

#define D dict_t
typedef struct D* D;

D dict_alloc();
void dict_free(D* d);
void dict_put(D d, char* key, void* value);
void* dict_at(D d, char* key);
bool dict_remove(D d, char* key);

#undef D

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

#undef D

#ifdef TEST_DICT

/**************
 * Test tools *
 **************/

struct int_entry {
    char* key;
    int value;
};

static dict_t create_int_dict(struct int_entry* entries) {
    dict_t result = dict_alloc();

    size_t i = 0;
    struct int_entry* e;
    while ((e = &entries[i++])->key != NULL) {
        dict_put(result, e->key, &(e->value));
    }

    return result;
}

/*********
 * Tests *
 *********/

static void test_alloc_and_free() {
    dict_t dict = dict_alloc();
    dict_free(&dict);
    assert(NULL == dict);
}

static void test_search() {
    struct int_entry entries[] = {
        {"a", 12},
        {"b", 34},
        {"c", 56},
        {"d", 78},
        {"e", 90},
        {NULL, 0},
    };
    dict_t d = create_int_dict(entries);

    int* result = dict_at(d, "b");

    assert(34 == *result);

    dict_free(&d);
}

static void test_remove() {
    struct int_entry entries[] = {
        {"a", 12},
        {"b", 34},
        {"c", 56},
        {"d", 78},
        {"e", 90},
        {NULL, 0},
    };
    dict_t d = create_int_dict(entries);

    bool is_removed = dict_remove(d, "b");
    assert(is_removed);

    int* search_result = dict_at(d, "b");
    assert(NULL == search_result);

    dict_free(&d);
}

int main() {
    test_alloc_and_free();
    test_search();
    test_remove();
    return 0;
}

#endif
