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

void test_size_of_empty_array() {
    int* numbers = NULL;
    aei(0, da_size(numbers));
}

void test_push_ten_values() {
    int* numbers = NULL;

    for (int i = 1; i <= 10; ++i) {
        da_push(numbers, i);
        aei(i, da_size(numbers));
        aei(i, numbers[i-1]);
    }
}

void test_string_dynarray() {
    char** strings = NULL;
    aei(0, da_size(strings));

    da_push(strings, "hello");

    assert(0 == strcmp("hello", strings[0]));
}

int main() {
    test_size_of_empty_array();
    test_push_ten_values();
    test_string_dynarray();
}
