#include <stddef.h>
#include <assert.h>
#include <error.h>
#include <string.h>

#include "dynarray.h"

/*********
 * Tools *
 *********/

static void aei(int expected, int actual) {
    if (expected != actual) {
        error(1, 0, "ASSERTION FAILED!\n⭕ %d\n❌ %d", expected, actual);
    }
}

/*********
 * Tests *
 *********/

void test_size_of_empty_array(void) {
    int* numbers = NULL;
    aei(0, da_size(numbers));
}

void test_free_empty_dyn_array(void) {
    int* numbers = NULL;
    da_free(numbers);
    assert(NULL == numbers);
}

void test_free_non_empty_dyn_array(void) {
    int* numbers = NULL;
    da_push(numbers, 9);
    da_free(numbers);
    assert(NULL == numbers);
}

void test_push_ten_values(void) {
    int* numbers = NULL;

    for (int i = 1; i <= 10; ++i) {
        da_push(numbers, i);
        aei(i, da_size(numbers));
        aei(i, numbers[i-1]);
    }
    da_free(numbers);
}

void test_string_dynarray(void) {
    char** strings = NULL;
    aei(0, da_size(strings));

    da_push(strings, "hello");

    assert(0 == strcmp("hello", strings[0]));
    da_free(strings);
}

int main(void) {
    test_size_of_empty_array();
    test_free_empty_dyn_array();
    test_free_non_empty_dyn_array();
    test_push_ten_values();
    test_string_dynarray();
}
