#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "treap.h"

/******************
 * Implementation *
 ******************/

#define T treap_t

struct T {
    struct treap_node* root;
    size_t size;
    cmp_fn cmp;
    fprint_fn fprint;
};

struct treap_node {
    void* key;
    double priority;
    void* value;
    struct treap_node* left;
    struct treap_node* right;
    struct treap_node* parent;
};

#define IS_ROOT(node) (NULL == node->parent)
#define IS_LEAF(node) (NULL == node->left && NULL == node->right)

T treap_alloc(cmp_fn cmp, fprint_fn fprint) {
    T result = calloc(1, sizeof(*result));
    assert(result);

    result->cmp = cmp;
    result->fprint = fprint;
    return result;
}

static void treap_node_free(struct treap_node* n) {
    if (NULL != n) {
        treap_node_free(n->left);
        treap_node_free(n->right);
        free(n);
    }
}

void treap_free(T* t) {
    assert(t);
    treap_node_free((*t)->root);
    free(*t);
    *t = NULL;
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
static void treap_right_rotate(T t, struct treap_node* x) {
    assert(x != NULL);
    assert(!IS_ROOT(x));

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
static void treap_left_rotate(T t, struct treap_node* x) {
    assert(x != NULL);
    assert(!IS_ROOT(x));

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

static struct treap_node* create_node(void* key, void* value, double priority) {
    struct treap_node* result = malloc(sizeof(*result));
    assert(result);

    result->key = key;
    result->priority = priority;
    result->value = value;
    result->left = NULL;
    result->right = NULL;
    result->parent = NULL;

    return result;
}

void treap_insert(T t, void* key, void* value, double priority) {
    struct treap_node* node = t->root;
    struct treap_node* parent = NULL;

    while (node != NULL) {
        parent = node;
        int cmp = t->cmp(key, node->key);
        if (cmp == 0) {
            node->value = value;
            return;
        }
        if (cmp < 0) {
            node = node->left;
        } else {
            node = node->right;
        }
    }

    struct treap_node* new_node = create_node(key, value, priority);
    assert(new_node != NULL);
    if (parent == NULL) {
        t->root = new_node;
        t->size++;
        return;
    } else if(t->cmp(key, parent->key) <= 0) {
        parent->left = new_node;
    } else {
        parent->right = new_node;
    }
    new_node->parent = parent;

    while (!IS_ROOT(new_node) &&
            (new_node->priority < new_node->parent->priority)) {
        if (new_node == new_node->parent->left) {
            treap_right_rotate(t, new_node);
        } else {
            treap_left_rotate(t, new_node);
        }
    }
    if (IS_ROOT(new_node)) {
        t->root = new_node;
    }

    t->size++;
}

static struct treap_node* treap_node_search(cmp_fn cmp, struct treap_node* node, void* key) {
    if (NULL == node) {
        return NULL;
    }
    const int n = cmp(key, node->key);
    if (n == 0) {
        return node;
    } else if (n < 0) {
        return treap_node_search(cmp, node->left, key);
    } else {
        return treap_node_search(cmp, node->right, key);
    }
}

void* treap_search(T t, void* key) {
    assert(t);
    struct treap_node* node = treap_node_search(t->cmp, t->root, key);
    if (NULL == node) {
        return NULL;
    }
    return node->value;
}

bool treap_remove(T t, void* key) {
    struct treap_node* node = treap_node_search(t->cmp, t->root, key);
    if (NULL == node) {
        return false;
    }
    if (IS_ROOT(node) && IS_LEAF(node)) {
        treap_node_free(t->root);
        t->root = NULL;
        t->size--;
        return true;
    }
    while (!IS_LEAF(node)) {
        struct treap_node* left = node->left;
        struct treap_node* right = node->right;
        if (NULL != left && (right == NULL || left->priority < right->priority)) {
            treap_right_rotate(t, left);
        } else {
            treap_left_rotate(t, right);
        }
        struct treap_node* parent = node->parent;
        if (IS_ROOT(parent)) {
            t->root = parent;
        }
    }
    if (node->parent->left == node) {
        node->parent->left = NULL;
    } else {
        node->parent->right = NULL;
    }
    treap_node_free(node);

    t->size--;
    return true;
}

size_t treap_size(T t) {
    return t->size;
}

static void treap_node_fprint(FILE* f, T t, struct treap_node* x, int depth) {
    if (x == NULL) {
        fprintf(f, "Empty tree.\n");
        return;
    }
    for (int i = 0; i < depth; ++i) {
        fprintf(f, "  ");
    }
    if (IS_ROOT(x)) {
        fprintf(f, "^:");
    } else if (x->parent->left == x) {
        fprintf(f, "<:");
    } else if (x->parent->right == x) {
        fprintf(f, ">:");
    } else {
        assert(NULL);
    }
    if (NULL != t->fprint) {
        t->fprint(f, x->key);
    } else {
        fprintf(f, "?");
    }
    fprintf(f, " - %.2f\n", x->priority);
    if (x->left != NULL) {
        treap_node_fprint(f, t, x->left, depth + 1);
    }
    if (x->right != NULL) {
        treap_node_fprint(f, t, x->right, depth +  1);
    }
}

void tfprint(FILE* f, T t) {
    treap_node_fprint(f, t, t->root, 0);
}

void tprint(T t) {
    tfprint(stdout, t);
}

#undef T
