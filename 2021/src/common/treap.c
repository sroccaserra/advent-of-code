#include <assert.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

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

struct treap_node* treap_create_node(char* key, double priority) {
    errno = 0;
    struct treap_node* result = malloc(sizeof(struct treap_node));
    if (result == NULL) {
        perror(key);
        assert(false);
    }

    result->key = key;
    result->priority = priority;
    result->left = NULL;
    result->right = NULL;
    result->parent = NULL;

    return result;
}

void treap_set_left(struct treap_node* node, struct treap_node* left) {
    node->left = left;
    if (left != NULL) {
        left->parent = node;
    }
}

void treap_set_right(struct treap_node* node, struct treap_node* right) {
    node->right = right;
    if (right != NULL) {
        right->parent = node;
    }
}

void treap_print(struct treap_node* x) {
    if (x->parent == NULL) {
        printf("Printing treap...\n");
    }
    printf("  treap_node: %s - %f ^ %s < %s > %s\n",
            x->key,
            x->priority,
            (x->parent == NULL) ? "null" : x->parent->key,
            (x->left == NULL) ? "null" : x->left->key,
            (x->right == NULL) ? "null" : x->right->key);
    if (x->left != NULL) {
        treap_print(x->left);
    }
    if (x->right != NULL) {
        treap_print(x->right);
    }
}

void treap_right_rotate(struct treap* t, struct treap_node* x) {
    assert(x != NULL);
    assert(x->parent != NULL);

    struct treap_node* y = x->parent;
    assert(y->left == x);

    struct treap_node* p = y->parent;
    if (p != NULL) {
        if (p->left == y) {
            treap_set_left(p, x);
        } else {
            treap_set_right(p, x);
        }
    }
    else {
        t->root = x;
        x->parent = NULL;
    }
    treap_set_left(y, x->right);
    treap_set_right(x, y);
}

void treap_left_rotate(struct treap* t, struct treap_node* x) {
    assert(x != NULL);
    assert(x->parent != NULL);

    struct treap_node* y = x->parent;
    assert(y->right == x);

    struct treap_node* p = y->parent;
    if (p != NULL) {
        if (p->left == y) {
            treap_set_left(p, x);
        } else {
            treap_set_right(p, x);
        }
    }
    else {
        t->root = x;
        x->parent = NULL;
    }
    treap_set_right(y, x->left);
    treap_set_left(x, y);
}

struct treap_node* treap_search(struct treap_node* node, char* key) {
    if (NULL == node) {
        return NULL;
    }
    int cmp = strcmp(key, node->key);
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
    struct treap_node* new_node = treap_create_node(key, priority);
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

#ifdef TEST

#define A(x,y) (assert(0 == strcmp(x, y)))

struct entry {
    char* name;
    double priority;
};

static void test_treap() {
    struct entry entries[] = {
        {"Bacon", 77},
        {"Butter", 76},
        {"Cabbage", 159},
        {"Eggs", 129},
        {"Floor", 10},
        {"Milk", 55},
        {"Pork", 56},
        {"Water", 32},
    };

    struct treap t;
    for (size_t i = 0; i < 8 ; ++i) {
        struct entry e = entries[i];
        treap_insert(&t, e.name, e.priority);
    }

    A("Floor", t.root->key); {
        A("Butter", t.root->left->key); {
            A("Bacon", t.root->left->left->key);
            A("Eggs", t.root->left->right->key); {
                A("Cabbage", t.root->left->right->left->key);
            }
        }
        A("Water", t.root->right->key); {
            A("Milk", t.root->right->left->key); {
                A("Pork", t.root->right->left->right->key);
            }
        }
    }

    treap_insert(&t, "Beer", 20);

    A("Floor", t.root->key); {
        A("Beer", t.root->left->key); {
            A("Bacon", t.root->left->left->key);
            A("Butter", t.root->left->right->key); {
                A("Eggs", t.root->left->right->right->key); {
                    A("Cabbage", t.root->left->right->right->left->key);
                }
            }
        }
        A("Water", t.root->right->key); {
            A("Milk", t.root->right->left->key); {
                A("Pork", t.root->right->left->right->key);
            }
        }
    }

}

int main() {
    test_treap();
}

#endif
