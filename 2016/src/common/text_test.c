#include "arena.h"
#include "text.h"

#include "testing.h"

void test_slurp() {
    long file_size = 414;
    struct arena arena = arena_alloc(file_size + 1);

    char *text = NULL;
    long size = slurp(&arena, "input/11", &text);

    assert_equals(file_size, size);
    assert_equals(file_size + 1, arena_used(&arena));

    arena_free(&arena);
}

void test_split_zero_lines() {
    struct arena arena = arena_alloc(64);
    char text[] = "";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(0, nb_lines);
    assert_null(lines);

    arena_free(&arena);
}

void test_split_one_line() {
    struct arena arena = arena_alloc(64);
    char text[] = "one line\n";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(1, nb_lines);
    assert_equals("one line", lines[0]);

    arena_free(&arena);
}

void test_split_one_line_without_eol() {
    struct arena arena = arena_alloc(64);
    char text[] = "one line";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(1, nb_lines);
    assert_equals("one line", lines[0]);

    arena_free(&arena);
}

void test_split_two_lines() {
    struct arena arena = arena_alloc(64);
    char text[] = "two\nlines\n";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(2, nb_lines);
    assert_equals("two", lines[0]);
    assert_equals("lines", lines[1]);
    assert_equals(nb_lines*sizeof(lines[0]), arena_used(&arena));

    arena_free(&arena);
}

void test_split_two_lines_without_last_eol() {
    struct arena arena = arena_alloc(64);
    char text[] = "two\nlines";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(2, nb_lines);
    assert_equals("two", lines[0]);
    assert_equals("lines", lines[1]);
    assert_equals(nb_lines*sizeof(lines[0]), arena_used(&arena));

    arena_free(&arena);
}

int main() {
    TEST_START("text");
    test_slurp();
    test_split_zero_lines();
    test_split_one_line();
    test_split_one_line_without_eol();
    test_split_two_lines();
    test_split_two_lines_without_last_eol();
    TEST_END;

    return 0;
}