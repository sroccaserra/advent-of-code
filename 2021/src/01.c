#include <assert.h>
#include <stdio.h>

#include "common/common.h"

#define HUGE 9999999

static int solve_1(int numbers[], size_t size) {
    int previous = HUGE;
    int result = 0;
    for (size_t i = 0; i < size; ++i) {
        int n = numbers[i];
        if (n > previous) {
            ++result;
        }
        previous = n;
    }
    return result;
}

static int solve_2(int numbers[], size_t size) {
    int p_1 = HUGE, p_2 = HUGE, p_3 = HUGE;
    int result = 0;
    for (size_t i = 0; i < size; ++i) {
        int n = numbers[i];
        if (n + p_1 + p_2 > p_1 + p_2 + p_3) {
            ++result;
        }
        p_3 = p_2;
        p_2 = p_1;
        p_1 = n;
    }
    return result;
}

int main() {
    size_t size;
    char** lines;
    int res = getlines("src/01.in", &lines, &size);
    assert(0 == res);

    int numbers[size];
    for (size_t i = 0; i < size; ++i) {
        char* line = lines[i];
        sscanf(line, "%d\n", &numbers[i]);
        free(line);
        lines[i] = NULL;
    }
    free(lines);
    lines = NULL;

    printf("%d\n%d\n",
            solve_1(numbers, size),
            solve_2(numbers, size));

    return 0;
}
