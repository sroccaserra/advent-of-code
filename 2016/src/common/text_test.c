#include "arena.h"
#include "text.h"

#include "testing.h"

void test_slurp() {
    long file_size = 414;
    struct arena arena = arena_init(file_size + 1);

    char *text = NULL;
    long size = slurp(&arena, "input/11", &text);

    assert_equals(file_size, size);
    assert_equals(file_size + 1, arena_used(&arena));

    arena_discard(&arena);
}

void test_split() {
    struct arena a = arena_init(128);
    char **items;
    int nb_items;

    // empty text
    char empty[] = "";
    items = NULL;
    nb_items = split(&a, empty, ",", &items);

    assert_equals(0, nb_items);
    assert_null(items);

    // no sep, not empty
    char one_item[] = "abc";
    items = NULL;
    nb_items = split(&a, one_item, ",", &items);

    assert_equals(1, nb_items);
    assert_equals("abc", items[0]);


    // two items
    char two_items[] = "abc,de";
    items = NULL;
    nb_items = split(&a, two_items, ",", &items);

    assert_equals(2, nb_items);
    assert_equals("abc", items[0]);
    assert_equals("de", items[1]);

    // sep at the beginning don't generates items
    char sep_at_the_beginning[] = ",abc,de";
    items = NULL;
    nb_items = split(&a, sep_at_the_beginning, ",", &items);

    assert_equals(2, nb_items);
    assert_equals("abc", items[0]);
    assert_equals("de", items[1]);

    // sep at the end don't generate items
    char sep_at_the_end[] = "abc,de,";
    items = NULL;
    nb_items = split(&a, sep_at_the_end, ",", &items);

    assert_equals(2, nb_items);
    assert_equals("abc", items[0]);
    assert_equals("de", items[1]);

    // consecutive seps don't generate items
    char two_seps[] = "abc,,de";
    items = NULL;
    nb_items = split(&a, two_seps, ",", &items);

    assert_equals(2, nb_items);
    assert_equals("abc", items[0]);
    assert_equals("de", items[1]);

    arena_discard(&a);
}

void test_split_zero_lines() {
    struct arena arena = arena_init(64);
    char text[] = "";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(0, nb_lines);
    assert_null(lines);

    arena_discard(&arena);
}

void test_split_one_line() {
    struct arena arena = arena_init(64);
    char text[] = "one line\n";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(1, nb_lines);
    assert_equals("one line", lines[0]);

    arena_discard(&arena);
}

void test_split_one_line_without_eol() {
    struct arena arena = arena_init(64);
    char text[] = "one line";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(1, nb_lines);
    assert_equals("one line", lines[0]);

    arena_discard(&arena);
}

void test_split_two_lines() {
    struct arena arena = arena_init(64);
    char text[] = "two\nlines\n";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(2, nb_lines);
    assert_equals("two", lines[0]);
    assert_equals("lines", lines[1]);
    assert_equals(nb_lines*sizeof(lines[0]), arena_used(&arena));

    arena_discard(&arena);
}

void test_split_two_lines_without_last_eol() {
    struct arena arena = arena_init(64);
    char text[] = "two\nlines";

    char **lines = NULL;
    int nb_lines = split_lines(&arena, text, &lines);

    assert_equals(2, nb_lines);
    assert_equals("two", lines[0]);
    assert_equals("lines", lines[1]);
    assert_equals(nb_lines*sizeof(lines[0]), arena_used(&arena));

    arena_discard(&arena);
}

int main() {
    TEST_START("text");
    test_slurp();
    test_split();
    test_split_zero_lines();
    test_split_one_line();
    test_split_one_line_without_eol();
    test_split_two_lines();
    test_split_two_lines_without_last_eol();
    TEST_END;

    return 0;
}
