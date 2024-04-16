#include <stddef.h>
#include <assert.h>
#include <error.h>

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

void test_push_a_value() {
    int* numbers = NULL;
    da_push(numbers, 9);
    aei(1, da_size(numbers));
}

int main() {
    test_size_of_empty_array();
    test_push_a_value();
}
