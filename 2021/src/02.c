#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <errno.h>
#include <assert.h>

struct CommandList {
    char direction;
    int value;
    struct CommandList* next;
};

static void solve(const struct CommandList* commands, int* result_1, int* result_2) {
    int hpos = 0, depth_1 = 0, depth_2 = 0, aim = 0;

    while (NULL != commands) {
        switch (commands->direction) {
            case 'f':
                hpos += commands->value;
                depth_2 += aim * commands->value;
                break;
            case 'u':
                depth_1 -= commands->value;
                aim -= commands->value;
                break;
            case 'd':
                depth_1 += commands->value;
                aim += commands->value;
                break;
            default:
                assert(false);
        }
        commands = commands->next;
    }

    *result_1 = hpos * depth_1;
    *result_2 = hpos * depth_2;
}

static void free_commands(struct CommandList* head) {
    while(head) {
        struct CommandList* next = head->next;
        free(head);
        head = next;
    }
}

int main() {
    const char* const filename = "src/02.in";
    FILE* file = fopen(filename, "r");
    if (NULL == file) {
        perror(filename);
        return 1;
    }

    char buffer[7];
    int n;
    struct CommandList* head = NULL;
    struct CommandList* last = NULL;
    while(EOF != fscanf(file, "%s %d\n", buffer, &n)) {
        struct CommandList* next = malloc(sizeof(*next));
        assert(next);
        next->direction = buffer[0];
        next->value = n;
        next->next = NULL;
        if (NULL == head) {
            head = next;
        }
        else {
            last->next = next;
        }
        last = next;
    }
    fclose(file);

    int result_1, result_2;
    solve(head, &result_1, &result_2);
    free_commands(head);
    printf("%d\n%d\n", result_1, result_2);
}
