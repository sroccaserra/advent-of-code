#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef struct CommandList {
    char direction;
    int value;
    struct CommandList* next;
} CommandList;

typedef struct {
    int first;
    int second;
} Results;

Results solve(CommandList* commands) {
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
            assert(NULL);
        }
        commands = commands->next;
    }

    return (Results){hpos * depth_1, hpos * depth_2};
}

int main() {
    FILE* file = fopen("src/02.in", "r");
    if (NULL == file) {
        printf("Error: file not found.\n");
        return 1;
    }

    char buffer[7];
    int n;
    CommandList* head = NULL;
    CommandList* last = NULL;
    while(EOF != fscanf(file, "%s %d\n", buffer, &n)) {
        CommandList* next = malloc(sizeof(CommandList));
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

    Results results = solve(head);
    printf("%d\n%d\n",
        results.first,
        results.second);
}
