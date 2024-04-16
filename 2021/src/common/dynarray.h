#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

typedef struct da_header {
    size_t size;
} da_header;

#define da_headerp(a) ((da_header*)(a) - 1)
#define da_push(a, v) (a = da_grow(a, sizeof(*(a))), \
        (a)[da_headerp(a)->size++] = (v))

#define da_grow_maybe(a, v) (da_grow(a, v))

size_t da_size(void* a) {
    if (a == NULL) {
        return 0;
    }
    da_header* h = da_headerp(a);
    return h->size;
}

void* da_grow(void* a, size_t amount) {
    void* b = realloc(a, amount+sizeof(da_header));
    assert(b);
    da_header* h = (da_header*)b;
    h->size = 0;
    b = (char*)b + sizeof(da_header);
    return b;
}
