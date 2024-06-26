#include <assert.h>

#include "dict.h"

/**************
 * Test tools *
 **************/

struct int_entry {
    char* key;
    int value;
};

static dict_t create_int_dict(struct int_entry* entries, size_t nb_entries) {
    dict_t result = str_dict_alloc();

    struct int_entry* e = entries;
    for (size_t i = 0; i < nb_entries; ++i, ++e) {
        dict_put(result, e->key, &(e->value));
    }
    return result;
}

#define CREATE_DICT(entries) (create_int_dict(entries, sizeof(entries)/sizeof(entries[0])))

/*********
 * Tests *
 *********/

static void test_alloc_and_free() {
    dict_t d = str_dict_alloc();
    assert(0 == dict_size(d));
    dict_free(&d);
    assert(NULL == d);
}

static void test_search() {
    struct int_entry entries[] = {
        {"a", 12},
        {"b", 34},
        {"c", 56},
        {"d", 78},
        {"e", 90},
    };
    dict_t d = CREATE_DICT(entries);
    assert(5 == dict_size(d));

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
    };
    dict_t d = CREATE_DICT(entries);

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
