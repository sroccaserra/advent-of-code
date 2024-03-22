#include <assert.h>
#include <err.h>
#include <error.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TREAP_R (1.0*rand()/RAND_MAX)

struct treap_node {
    char* key;
    double priority;

    struct treap_node* left;
    struct treap_node* right;
    struct treap_node* parent;
};

struct treap {
    struct treap_node* root;
};

static struct treap_node* create_node(char* key, double priority) {
    struct treap_node* result = malloc(sizeof(struct treap_node));
    if (result == NULL) {
        err(1, "key: %s", key);
    }

    result->key = key;
    result->priority = priority;
    result->left = NULL;
    result->right = NULL;
    result->parent = NULL;

    return result;
}

static void treap_set_left(struct treap_node* node, struct treap_node* left) {
    node->left = left;
    if (left != NULL) {
        left->parent = node;
    }
}

static void treap_set_right(struct treap_node* node, struct treap_node* right) {
    node->right = right;
    if (right != NULL) {
        right->parent = node;
    }
}

/**
 *       y          x
 *      / \        / \
 *     x   c  ->  a   y
 *    / \            / \
 *   a   b          b   c
 */
static void treap_right_rotate(struct treap* t, struct treap_node* x) {
    assert(x != NULL);
    assert(x->parent != NULL);

    struct treap_node* y = x->parent;
    assert(y->left == x);

    struct treap_node* p = y->parent;
    if (p == NULL) {
        t->root = x;
        x->parent = NULL;
    } else {
        if (p->left == y) {
            treap_set_left(p, x);
        } else {
            treap_set_right(p, x);
        }
    }
    treap_set_left(y, x->right);
    treap_set_right(x, y);
}

/**
 *     y          x
 *    / \        / \
 *   a   x  ->  y   c
 *      / \    / \
 *     b   c  a   b
 */
static void treap_left_rotate(struct treap* t, struct treap_node* x) {
    assert(x != NULL);
    assert(x->parent != NULL);

    struct treap_node* y = x->parent;
    assert(y->right == x);

    struct treap_node* p = y->parent;
    if (p == NULL) {
        t->root = x;
        x->parent = NULL;
    }
    else {
        if (p->left == y) {
            treap_set_left(p, x);
        } else {
            treap_set_right(p, x);
        }
    }
    treap_set_right(y, x->left);
    treap_set_left(x, y);
}

struct treap_node* treap_search(struct treap_node* node, char* key) {
    if (NULL == node) {
        return NULL;
    }
    const int cmp = strcmp(key, node->key);
    if (cmp == 0) {
        return node;
    } else if (cmp < 0) {
        return treap_search(node->left, key);
    } else {
        return treap_search(node->right, key);
    }
}

void treap_insert(struct treap* t, char* key, double priority) {
    struct treap_node* node = t->root;
    struct treap_node* parent = NULL;
    struct treap_node* new_node = create_node(key, priority);
    assert(new_node != NULL);

    while (node != NULL) {
        parent = node;
        if (strcmp(key, node->key) <= 0) {
            node = node->left;
        } else {
            node = node->right;
        }
    }
    if (parent == NULL) {
        t->root = new_node;
        return;
    } else if(strcmp(key, parent->key) <= 0) {
        parent->left = new_node;
    } else {
        parent->right = new_node;
    }
    new_node->parent = parent;

    while ((new_node->parent != NULL) &&
            (new_node->priority < new_node->parent->priority)) {
        if (new_node == new_node->parent->left) {
            treap_right_rotate(t, new_node);
        } else {
            treap_left_rotate(t, new_node);
        }
    }
    if (new_node->parent == NULL) {
        t->root = new_node;
    }
}

static void tnfprint(FILE* f, struct treap_node* x, int depth) {
    if (x == NULL) {
        fprintf(f, "Empty tree.\n");
        return;
    }
    for (int i = 0; i < depth; ++i) {
        fprintf(f, "  ");
    }
    fprintf(f, "%s - %.2f\n", x->key, x->priority);
    if (x->left != NULL) {
        tnfprint(f, x->left, depth + 1);
    }
    if (x->right != NULL) {
        tnfprint(f, x->right, depth +  1);
    }
}

void tfprint(FILE* f, struct treap* t) {
    tnfprint(f, t->root, 0);
}

void tprint(struct treap* t) {
    tfprint(stdout, t);
}

#ifdef TEST

static void aes(char* expected, char* actual) {
    if (NULL == expected) {
        expected = "(NULL)";
    }
    if (NULL == actual) {
        actual = "(NULL)";
    }
    if (0 != strcmp(expected, actual)) {
        error(1, 0, "ASSERTION FAILED!\n⭕\n%s\n❌\n%s", expected, actual);
    }
}

#define BUF_SIZE 4096

static void tsprint(char* buf, struct treap* t) {
    FILE* f = fmemopen(buf, BUF_SIZE, "w");
    tfprint(f, t);
    fclose(f);
}

struct entry {
    char* key;
    double priority;
};

static void test_insert_exemple_from_book() {
    struct entry entries[] = {
        {"Bacon", 77},
        {"Beer", 20},
        {"Butter", 76},
        {"Cabbage", 159},
        {"Eggs", 129},
        {"Floor", 10},
        {"Milk", 55},
        {"Pork", 56},
        {"Water", 32},
        {NULL, 0},
    };
    struct treap t = {};
    size_t i = 0;
    struct entry e;
    while ((e = entries[i++]).key != NULL) {
        treap_insert(&t, e.key, e.priority);
    }

    char buf[BUF_SIZE];
    tsprint(buf, &t);

    aes("Floor - 10.00\n"
            "  Beer - 20.00\n"
            "    Bacon - 77.00\n"
            "    Butter - 76.00\n"
            "      Eggs - 129.00\n"
            "        Cabbage - 159.00\n"
            "  Water - 32.00\n"
            "    Milk - 55.00\n"
            "      Pork - 56.00\n"
            , buf);
}

int main() {
    test_insert_exemple_from_book();
    return 0;
}

#endif
