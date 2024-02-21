#include <stdio.h>

#include "common/IntVector.h"

#define HUGE 9999999

int solve_1(IntVector* numbers) {
    int previous = HUGE;
    int result = 0;
    for (size_t i = 0; i < numbers->size; ++i) {
        int n = getInt(numbers, i);
        if (n > previous) {
            ++result;
        }
        previous = n;
    }
    return result;
}

int solve_2(IntVector* numbers) {
    int p_1 = HUGE, p_2 = HUGE, p_3 = HUGE;
    int result = 0;
    for (size_t i = 0; i < numbers->size; ++i) {
        int n = getInt(numbers, i);
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
    FILE *file = fopen("src/01.in", "r");
    if (NULL == file) {
        printf("Error: file not found.\n");
        return 1;
    }

    IntVector numbers = createIntVector();
    int n;
    while(EOF != fscanf(file, "%d\n", &n)) {
        pushInt(&numbers, n);
    }
    fclose(file);

    printf("%d\n%d\n",
            solve_1(&numbers),
            solve_2(&numbers));

    return 0;
}
