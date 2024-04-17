SHELL=/bin/bash -euo pipefail

SRC_COMMON := $(wildcard src/common/*.c)
OBJ_COMMON := $(SRC_COMMON:src/common/%.c=build/%.o)
SRC_COMMON_NO_TEST := $(filter-out $(wildcard src/common/*_test.c), $(SRC_COMMON))
OBJ_COMMON_NO_TEST := $(SRC_COMMON_NO_TEST:src/common/%.c=build/%.o)

CFLAGS := -std=c18 -Wall -Wextra -Wpedantic -Werror -g -D_POSIX_C_SOURCE
CPPFLAGS := -Isrc/common -MMD -MP
LDLIBS := -lc

default: test

##
# Common

build:
	mkdir -p build

.PHONY: clean
clean:
	rm -rf build/*

##
# C

.PHONY: test
test: dynarray_test

.PRECIOUS: build/%.o
build/%.o: src/common/%.c | build
	gcc $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

.PRECIOUS: build/%_test
build/%_test: $(OBJ_COMMON_NO_TEST) build/%_test.o
	gcc $(CFLAGS) $^ $(LDLIBS) -o $@

.PHONY: %_test
%_test: build/%_test | build
	@$<

.PRECIOUS: build/%
build/%: src/%.c $(OBJ_COMMON_NO_TEST) | build
	gcc $(CFLAGS) -o $@ $^

.PHONY: %
%: build/%
	@$< src/$*.in

-include $(OBJ_COMMON:.o=.d)
