#include <stdio.h>
#include <assert.h>
#include <string.h>

int equals_int(int expected, int actual) {
    if (expected != actual) {
        fprintf(stderr, "ASSERTION FAILED!\n⭕ %d\n❌ %d\n", expected, actual);
        return 0;
    }
    return 1;
}

int equals_str(char *expected, char *actual) {
    if (0 != strcmp(expected, actual)) {
        fprintf(stderr, "ASSERTION FAILED!\n⭕ %s\n❌ %s\n", expected, actual);
        return 0;
    }
    return 1;
}

#define ae_eq(e, a) _Generic((e), int: equals_int, char *: equals_str)(e, a)
#define assert_equals(e, a) (assert(ae_eq(e, a)))
