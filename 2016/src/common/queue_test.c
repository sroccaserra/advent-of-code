#include "testing.h"
#include "queue.h"
#include "arena.h"

/*
 * TODO:
 *
 * - grow somehow (?)
 * - free mem somehow (?)
 *
 * Questions
 * - should it work with an arena?
 * - if we need to implement capacity growth and realloc, we then
 *   need to implement it in arena also. Then it's a bit like
 *   using malloc since it's mostly a queue of pointers (?), is
 *   it worth it? Why not directly use malloc then?
 * - let's make it work with an arena, and not implement growth
 */

void test_size_of_empty_queue_is_zero() {
    struct arena a = arena_init(128);
    struct queue *q = queue_init(&a, 1);

    size_t result = queue_size(q);

    assert_equals(0, result);
    arena_discard(&a);
}

void test_appending_one_value_increments_size() {
    struct arena a = arena_init(128);
    struct queue *q = queue_init(&a, 1);

    queue_append(q, "yellow");
    size_t result = queue_size(q);

    assert_equals(1, result);
    arena_discard(&a);
}

void test_removing_a_value() {
    struct arena a = arena_init(128);
    struct queue *q = queue_init(&a, 2);

    queue_append(q, "yellow");
    char *result = queue_remove(q);

    assert_equals("yellow", result);
    assert_equals(0, queue_size(q));
    arena_discard(&a);
}

void test_appending_two_values_and_remove_one() {
    struct arena a = arena_init(128);
    struct queue *q = queue_init(&a, 2);

    queue_append(q, "hellow");
    queue_append(q, "yellow");
    char *result = queue_remove(q);

    assert_equals("hellow", result);
    assert_equals(1, queue_size(q));
    arena_discard(&a);
}

void test_circular_behavior_of_end() {
    struct arena a = arena_init(sizeof(struct queue) + 3*sizeof(void *));
    struct queue *q = queue_init(&a, 3);

    queue_append(q, "one");
    queue_append(q, "two");
    queue_append(q, "three");
    queue_remove(q);
    queue_append(q, "four");
    char *result = queue_remove(q);

    assert_equals("two", result);
    assert_equals(2, queue_size(q));
    arena_discard(&a);
}

void test_circular_behavior_of_begin() {
    struct arena a = arena_init(sizeof(struct queue) + 3*sizeof(void *));
    struct queue *q = queue_init(&a, 3);

    // ...
    queue_append(q, "one");         // 1..
    queue_append(q, "two");         // 12.
    queue_append(q, "three");       // 123
    queue_remove(q);                // .23
    queue_append(q, "four");        // 423
    queue_remove(q);                // 4.3
    char *result = queue_remove(q); // 4..

    assert_equals("three", result);
    assert_equals(1, queue_size(q));
    result = queue_remove(q);       // ...
    assert_equals("four", result);
    assert_equals(0, queue_size(q));
    arena_discard(&a);
}

int main() {
    TEST_BEGIN("queue");
    test_size_of_empty_queue_is_zero();
    test_appending_one_value_increments_size();
    test_removing_a_value();
    test_appending_two_values_and_remove_one();
    test_circular_behavior_of_end();
    test_circular_behavior_of_begin();
    TEST_END;
}
