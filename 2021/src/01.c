#include <assert.h>
#include <stdio.h>

#include "common/common.h"
#include "common/dynarray.h"

#define HUGE 9999999

static int solve_1(int* numbers) {
    int previous = HUGE;
    int result = 0;
    size_t size = numbers[0];
    for (size_t i = 1; i <= size; ++i) {
        int n = numbers[i];
        if (n > previous) {
            ++result;
        }
        previous = n;
    }
    return result;
}

static int solve_2(int* numbers) {
    int p_1 = HUGE, p_2 = HUGE, p_3 = HUGE;
    int result = 0;
    size_t size = numbers[0];
    for (size_t i = 1; i <= size; ++i) {
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
    char** lines;
    int res = getlines("src/01.in", &lines);
    assert(0 == res);

    size_t nb_lines = da_size(lines);
    int numbers[nb_lines+1];
    numbers[0] = nb_lines; // Use firt value as size => 1-indexed array, like Lua & Smalltalk
    for (size_t i = 0; i < nb_lines; ++i) {
        char* line = lines[i];
        sscanf(line, "%d\n", &numbers[i+1]);
        free(line);
        lines[i] = NULL;
    }
    da_free(lines);

    printf("%d\n%d\n",
            solve_1(numbers),
            solve_2(numbers));

    return 0;
}
