#include <stdio.h>
#include <assert.h>

#include "common/IntVector.h"

typedef struct {
    int first;
    int second;
} Results;

Results solve(IntVector* directions, IntVector* values) {
    int hpos = 0, depth_1 = 0, depth_2 = 0, aim = 0;

    for (size_t i = 0; i < directions->size; ++i) {
        int direction = getInt(directions, i);
        int value = getInt(values, i);
        switch (direction) {
            case 'f':
            hpos += value;
            depth_2 += aim * value;
            break;
        case 'u':
            depth_1 -= value;
            aim -= value;
            break;
        case 'd':
            depth_1 += value;
            aim += value;
            break;
        default:
            assert(NULL);
        }
    }

    return (Results){hpos * depth_1, hpos * depth_2};
}

int main() {
    FILE* file = fopen("src/02.in", "r");
    if (NULL == file) {
        printf("Error: file not found.\n");
        return 1;
    }

    IntVector directions = createIntVector();
    IntVector values = createIntVector();
    char buffer[7];
    int n;
    while(EOF != fscanf(file, "%s %d\n", buffer, &n)) {
        pushInt(&directions, buffer[0]);
        pushInt(&values, n);
    }
    fclose(file);

    Results results = solve(&directions, &values);
    printf("%d\n%d\n",
        results.first,
        results.second);
}
