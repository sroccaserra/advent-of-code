#include "testing.h"
#include "arena.h"
#include "astring.h"

void test_make_astring() {
    struct arena a = arena_init(128);
    struct astring *s = astring_init(&a, "hello");
    assert_equals(5, s->size);
    assert_equals("hello", s->items);
    arena_discard(&a);
}

void test_split_an_empty_cstring() {
    struct arena a = arena_init(128);
    struct astring_list *astrings = astring_split(&a, "", " ");
    assert_equals(0, astrings->size);
    assert_equals(NULL, astrings->items);
    arena_discard(&a);
}

void test_split_a_cstring_with_missing_sep() {
    struct arena a = arena_init(128);
    struct astring_list *result = astring_split(&a, "bob", " ");
    assert_equals(1, result->size);
    struct astring first = result->items[0];
    assert_equals(3, first.size);
    arena_discard(&a);
}

void test_split_a_cstring_with_a_sep() {
    struct arena a = arena_init(128);
    struct astring_list *astrings = astring_split(&a, "bob alice", " ");
    assert_equals(2, astrings->size);

    struct astring first = astrings->items[0];
    assert_equals(strlen("bob"), first.size);
    assert(astring_is_same(&first, "bob"));

    struct astring second = astrings->items[1];
    assert_equals(strlen("alice"), second.size);
    assert(astring_is_same(&second, "alice"));

    arena_discard(&a);
}

void test_split_a_cstring_with_two_seps() {
    struct arena a = arena_init(128);
    struct astring_list *astrings = astring_split(&a, "bob alice mary", " ");
    assert_equals(3, astrings->size);

    struct astring first = astrings->items[0];
    assert_equals(strlen("bob"), first.size);
    assert(astring_is_same(&first, "bob"));

    struct astring second = astrings->items[1];
    assert_equals(strlen("alice"), second.size);
    assert(astring_is_same(&second, "alice"));

    struct astring third = astrings->items[2];
    assert_equals(strlen("mary"), third.size);
    assert(astring_is_same(&third, "mary"));

    arena_discard(&a);
}

void test_convert_to_c_string() {
    struct arena a = arena_init(128);
    struct astring *s = astring_init(&a, "hello");

    char *result = astring_to_cstr(&a, s);

    assert_equals("hello", result);
    arena_discard(&a);
}

void test_convert_to_c_string_with_more_data() {
    struct arena a = arena_init(128);
    struct astring *s = astring_init_ln(&a, "hello, world", 5);

    char *result = astring_to_cstr(&a, s);

    assert_equals("hello", result);
    arena_discard(&a);
}

void test_print_to_buffer() {
    struct arena a = arena_init(128);
    struct astring *s = astring_init_ln(&a, "hello, world", 5);

    char *result = malloc(6);
    int size = astring_sprint(s, result);

    assert_equals(5, size);
    assert_equals("hello", result);

    arena_discard(&a);
}

int main() {
    TEST_BEGIN("astring");
    test_make_astring();
    test_split_an_empty_cstring();
    test_split_a_cstring_with_missing_sep();
    test_split_a_cstring_with_a_sep();
    test_split_a_cstring_with_two_seps();
    test_convert_to_c_string();
    test_convert_to_c_string_with_more_data();
    test_print_to_buffer();
    TEST_END;
}
