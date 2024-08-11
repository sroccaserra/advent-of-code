#include "testing.h"
#include "queue.h"
#include "arena.h"

/*
 * TODO:
 *
 * - wrap around somehow
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
    struct queue *q = queue_init(&a, 128 - sizeof(struct queue));

    size_t result = queue_size(q);

    assert_equals(0, result);
    arena_discard(&a);
}

void test_appending_one_value_increments_size() {
    struct arena a = arena_init(128);
    struct queue *q = queue_init(&a, 64);

    queue_append(q, "yellow");
    size_t result = queue_size(q);

    assert_equals(1, result);
    arena_discard(&a);
}

void test_removing_a_value() {
    struct arena a = arena_init(128);
    struct queue *q = queue_init(&a, 64);

    queue_append(q, "yellow");
    char *result = queue_remove(q);

    assert_equals("yellow", result);
    assert_equals(0, queue_size(q));
    arena_discard(&a);
}

int main() {
    TEST_BEGIN("queue");
    test_size_of_empty_queue_is_zero();
    test_appending_one_value_increments_size();
    test_removing_a_value();
    TEST_END;
}
