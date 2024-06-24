#ifndef TESTING_H
#define TESTING_H

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdint.h>

#define TEST_START(s) (printf("Testing "s"..."), fflush(stdout))
#define TEST_END (printf(" ✅ OK.\n"))

int equals_uint64_t(uint64_t expected, uint64_t actual) {
    if (expected != actual) {
        fprintf(stderr, "ASSERTION FAILED!\n👉 %ld\n❌ %ld\n", expected, actual);
        return 0;
    }
    return 1;
}

int equals_int(int expected, int actual) {
    if (expected != actual) {
        fprintf(stderr, "ASSERTION FAILED!\n👉 %d\n❌ %d\n", expected, actual);
        return 0;
    }
    return 1;
}

int equals_str(char *expected, char *actual) {
    if (0 != strcmp(expected, actual)) {
        fprintf(stderr, "ASSERTION FAILED!\n👉 %s\n❌ %s\n", expected, actual);
        return 0;
    }
    return 1;
}

#define ae_eq(e, a) _Generic((e), uint64_t: equals_uint64_t, int: equals_int, char *: equals_str)(e, a)
#define assert_equals(e, a) (assert(ae_eq(e, a)))

int check_null(void* p) {
    if (NULL != p) {
        fprintf(stderr, "ASSERTION FAILED!\n👉 %p\n❌ %p\n", NULL, p);
        return 0;
    }
    return 1;
}

#define assert_null(p) (assert(check_null(p)))

#endif
