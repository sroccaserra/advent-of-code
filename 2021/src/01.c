#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

///
// Define a dynamic int array structure, because why not?

struct IntVector_s {
    int* data;
    size_t size;
    size_t max_size;
};

typedef struct IntVector_s IntVector;

const size_t default_size = 8;

IntVector createIntVector() {
    int* data = malloc(sizeof(int[default_size]));
    assert(NULL != data);
    return (IntVector){.data = data, .size = 0, .max_size = default_size};
}

void deleteIntVector(IntVector* v) {
    assert(NULL != v);
    assert(NULL != v->data);

    free(v->data);
    v->data = NULL;
    v->size = 0;
    v->max_size = default_size;
}

void resizeIntVector(IntVector* v, size_t new_max_size) {
    assert(NULL != v);
    assert(NULL != v->data);
    assert(v->max_size < new_max_size);

    int* data = realloc(v->data, sizeof(int[new_max_size]));
    assert(NULL != data);

    v->data = data;
    v->max_size = new_max_size;
}

int getInt(IntVector* v, size_t pos) {
    assert(pos < v->size);
    return v->data[pos];
}

void setInt(IntVector* v, size_t pos, int value) {
    assert(pos < v->size);
    v->data[pos] = value;
}

void pushInt(IntVector* v, int value) {
    size_t new_pos = v->size;
    if (v->max_size <= new_pos) {
        resizeIntVector(v, 2*v->max_size);
    }
    assert (new_pos < v->max_size);
    v->data[new_pos] =value;
    v->size += 1;
}

///
// Solving

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
