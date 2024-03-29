#include <assert.h>
#include <error.h>
#include <stdio.h>
#include <string.h>

#include "treap.h"

/**************
 * Test tools *
 **************/

static void aei(int expected, int actual) {
    if (expected != actual) {
        error(1, 0, "ASSERTION FAILED!\n⭕ %d\n❌ %d", expected, actual);
    }
}

static void aes(char* expected, char* actual) {
    if (NULL == expected) {
        expected = "(NULL)";
    }
    if (NULL == actual) {
        actual = "(NULL)";
    }
    if (0 != strcmp(expected, actual)) {
        error(1, 0, "ASSERTION FAILED!\n⭕\n%s\n❌\n%s", expected, actual);
    }
}

#define BUF_SIZE 4096

extern FILE* fmemopen(void* buf, size_t size, const char* mode);

static void treap_sprint(char* buf, treap_t t) {
    FILE* f = fmemopen(buf, BUF_SIZE, "w");
    treap_fprint(f, t);
    fclose(f);
}

struct test_entry {
    char* key;
    double priority;
    void* value;
};

static void fprint_entry(FILE* f, const void* entry) {
    fprintf(f, "%s", (char*)entry);
}

static treap_t create_treap(struct test_entry* entries, size_t nb_entries) {
    treap_t result = treap_alloc((cmp_fn)strcmp, fprint_entry);

    struct test_entry* e = entries;
    for (size_t i = 0; i < nb_entries; ++i, ++e) {
        treap_insert(result, e->key, e->value, e->priority);
    }
    return result;;
}

#define CREATE_TREAP(entries) (create_treap(entries, sizeof(entries)/sizeof(entries[0])))

/*********
 * Tests *
 *********/

static void test_treap_free_sets_pointer_to_null() {
    treap_t t = treap_alloc((cmp_fn)strcmp, fprint_entry);
    treap_free(&t);

    assert(t == NULL);
}

static void test_insert_exemple_from_book() {
    struct test_entry entries[] = {
        {"Bacon", 77, NULL},
        {"Beer", 20, NULL},
        {"Butter", 76, NULL},
        {"Cabbage", 159, NULL},
        {"Eggs", 129, NULL},
        {"Floor", 10, NULL},
        {"Milk", 55, NULL},
        {"Pork", 56, NULL},
        {"Water", 32, NULL},
    };
    treap_t t = CREATE_TREAP(entries);

    char buf[BUF_SIZE];
    treap_sprint(buf, t);

    aes("^:Floor - 10.00\n"
            "  <:Beer - 20.00\n"
            "    <:Bacon - 77.00\n"
            "    >:Butter - 76.00\n"
            "      >:Eggs - 129.00\n"
            "        <:Cabbage - 159.00\n"
            "  >:Water - 32.00\n"
            "    <:Milk - 55.00\n"
            "      >:Pork - 56.00\n"
            , buf);

    treap_free(&t);
}

static void test_insert_to_same_key_updates_value() {
    struct test_entry entries[] = {
        {"Bacon", 77, NULL},
        {"Beer", 20, NULL},
        {"Butter", 76, NULL},
        {"Cabbage", 159, NULL},
        {"Eggs", 129, NULL},
        {"Floor", 10, NULL},
        {"Milk", 55, NULL},
        {"Pork", 56, NULL},
        {"Water", 32, NULL},
    };
    treap_t t = CREATE_TREAP(entries);

    int value = 1234;
    treap_insert(t, "Eggs", &value, 129);

    int* result = treap_search(t, "Eggs");

    assert(1234 == *result);
    aei(9, treap_size(t));

    treap_free(&t);
}

static void test_search() {
    int value = 1234;
    struct test_entry entries[] = {
        {"Bacon", 77, &value},
        {"Beer", 20, NULL},
        {"Butter", 76, NULL},
        {"Cabbage", 159, NULL},
        {"Eggs", 129, NULL},
        {"Floor", 10, NULL},
        {"Milk", 55, NULL},
        {"Pork", 56, NULL},
        {"Water", 32, NULL},
    };
    treap_t t = CREATE_TREAP(entries);

    int* result = treap_search(t, "Bacon");
    assert(1234 == *result);

    result = treap_search(t, "dontexist");
    assert(NULL == result);

    treap_free(&t);
}

static void test_remove() {
    struct test_entry entries[] = {
        {"Beer", 20, NULL},
        {"Beet", 81, NULL},
        {"Butter", 76, NULL},
        {"Cabbage", 159, NULL},
        {"Eggs", 129, NULL},
        {"Floor", 10, NULL},
        {"Milk", 55, NULL},
        {"Pork", 56, NULL},
        {"Water", 32, NULL},
    };
    treap_t t = CREATE_TREAP(entries);

    char buf[BUF_SIZE];
    treap_sprint(buf, t);

    aes("^:Floor - 10.00\n"
            "  <:Beer - 20.00\n"
            "    >:Butter - 76.00\n"
            "      <:Beet - 81.00\n"
            "      >:Eggs - 129.00\n"
            "        <:Cabbage - 159.00\n"
            "  >:Water - 32.00\n"
            "    <:Milk - 55.00\n"
            "      >:Pork - 56.00\n"
            , buf);

    bool result = treap_remove(t, "Butter");

    assert(result);
    treap_sprint(buf, t);
    aes("^:Floor - 10.00\n"
            "  <:Beer - 20.00\n"
            "    >:Beet - 81.00\n"
            "      >:Eggs - 129.00\n"
            "        <:Cabbage - 159.00\n"
            "  >:Water - 32.00\n"
            "    <:Milk - 55.00\n"
            "      >:Pork - 56.00\n"
            , buf);


    treap_free(&t);
}

static void test_size() {
    struct test_entry entries[] = {
        {"Beer", 20, NULL},
        {"Beet", 81, NULL},
        {"Butter", 76, NULL},
        {"Cabbage", 159, NULL},
        {"Eggs", 129, NULL},
        {"Floor", 10, NULL},
        {"Milk", 55, NULL},
        {"Pork", 56, NULL},
        {"Water", 32, NULL},
    };
    treap_t t = CREATE_TREAP(entries);

    size_t result = treap_size(t);
    aei(9, result);

    treap_remove(t, "Butter");
    result = treap_size(t);
    aei(8, result);

    treap_free(&t);
}

int main() {
    test_treap_free_sets_pointer_to_null();
    test_insert_exemple_from_book();
    test_insert_to_same_key_updates_value();
    test_search();
    test_remove();
    test_size();
    return 0;
}
