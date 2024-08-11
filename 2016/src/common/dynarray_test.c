#include <stddef.h>
#include <assert.h>
#include <error.h>
#include <string.h>

#include "testing.h"
#include "dynarray.h"

void test_size_of_empty_array(void) {
    int *numbers = NULL;
    assert_equals(0, da_size(numbers));
}

void test_free_empty_dyn_array(void) {
    int *numbers = NULL;
    da_free(numbers);
    assert_null(numbers);
}

void test_free_non_empty_dyn_array(void) {
    int *numbers = NULL;
    da_push(numbers, 9);
    da_free(numbers);
    assert_null(numbers);
}

void test_free_items_of_empty_da(void) {
    char **buffers = NULL;
    da_free_items(buffers);
}

void test_free_items(void) {
    char **buffers = NULL;
    char *buffer_1 = malloc(10*sizeof(char));
    char *buffer_2 = malloc(20*sizeof(char));
    da_push(buffers, buffer_1);
    da_push(buffers, buffer_2);
    assert(buffers[0]);
    assert(buffers[1]);

    da_free_items(buffers);

    assert_null(buffers[0]);
    assert_null(buffers[1]);

    da_free(buffers);
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

    assert_equals("hello", strings[0]);
    da_free(strings);
}

int main(void) {
    TEST_BEGIN("dynarray");
    test_size_of_empty_array();
    test_free_empty_dyn_array();
    test_free_non_empty_dyn_array();
    test_push_ten_values();
    test_string_dynarray();
    test_free_items();
    test_free_items_of_empty_da();
    TEST_END;
}
