SHELL=/bin/bash -euo pipefail

CFLAGS := -std=c18 -Wall -Wextra -Wpedantic -Werror -g -D_POSIX_C_SOURCE
CPPFLAGS := -MMD -MP
LDLIBS := -lc

TEST_C_FILES := $(wildcard src/common/*_test.c)
COMMON_C_FILES := $(wildcard src/common/*.c)
COMMON_C_FILES_NO_TEST := $(filter-out $(TEST_C_FILES), $(COMMON_C_FILES))
COMMON_OBJ_FILES := $(COMMON_C_FILES:src/common/%.c=build/%.o)
MAIN_C_FILES := $(wildcard src/*.c)

# Used in targets
COMMON_OBJ_FILES_NO_TEST := $(COMMON_C_FILES_NO_TEST:src/common/%.c=build/%.o)
COMMON_D_FILES := $(COMMON_OBJ_FILES:.o=.d)
MAIN_D_FILES := $(MAIN_C_FILES:src/%.c=build/%.d)

default: test

##
# Common

build:
	mkdir -p build

.PHONY: clean
clean:
	rm -rf build/*

##
# Main

.PRECIOUS: build/%.o
build/%.o: src/common/%.c | build
	gcc $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

.PRECIOUS: build/%
build/%: src/%.c $(COMMON_OBJ_FILES_NO_TEST) | build
	gcc -o $@ $^ $(CPPFLAGS) $(CFLAGS)

.PHONY: %
%: build/% | build
	@$< $(INPUT)

##
# Tests

.PHONY: test
test: dynarray_test

.PHONY: %_test
%_test: build/%_test | build
	@$<

.PRECIOUS: build/%_test
build/%_test: $(COMMON_OBJ_FILES_NO_TEST) build/%_test.o | build
	gcc $(CFLAGS) $^ $(LDLIBS) -o $@

##
# Generated Deps

-include $(COMMON_D_FILES)
-include $(MAIN_D_FILES)
