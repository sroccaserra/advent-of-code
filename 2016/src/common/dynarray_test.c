#include <stddef.h>
#include <assert.h>
#include <error.h>
#include <string.h>

#include "dynarray.h"
#include "testing.h"

void test_size_of_empty_array(void) {
    int *numbers = NULL;
    assert_equals(0, da_size(numbers));
}

void test_free_empty_dyn_array(void) {
    int *numbers = NULL;
    da_free(numbers);
    assert(NULL == numbers);
}

void test_free_non_empty_dyn_array(void) {
    int *numbers = NULL;
    da_push(numbers, 9);
    da_free(numbers);
    assert(NULL == numbers);
}

void test_push_ten_values(void) {
    int *numbers = NULL;

    for (int i = 1; i <= 10; ++i) {
        da_push(numbers, i);
        assert_equals(i, da_size(numbers));
        assert_equals(i, numbers[i-1]);
    }
    da_free(numbers);
}

void test_string_dynarray(void) {
    char **strings = NULL;
    assert_equals(0, da_size(strings));

    da_push(strings, "hello");

    assert(0 == strcmp("hello", strings[0]));
    da_free(strings);
}

int main(void) {
    TEST_START("dynarray");
    test_size_of_empty_array();
    test_free_empty_dyn_array();
    test_free_non_empty_dyn_array();
    test_push_ten_values();
    test_string_dynarray();
    TEST_END;
}
