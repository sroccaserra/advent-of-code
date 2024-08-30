SHELL=/bin/bash -euo pipefail

CFLAGS := -std=c18 -Wall -Wextra -Wpedantic -Werror -g -D_POSIX_C_SOURCE
CPPFLAGS := -MMD -MP
LDLIBS := -lc

TEST_C_FILES := $(wildcard src/common/*_test.c)
COMMON_C_FILES := $(wildcard src/common/*.c)
COMMON_C_FILES_NO_TEST := $(filter-out $(TEST_C_FILES), $(COMMON_C_FILES))
COMMON_OBJ_FILES := $(COMMON_C_FILES:src/common/%.c=build/common/%.o)
MAIN_C_FILES := $(wildcard src/*.c)

# Used in targets
COMMON_OBJ_FILES_NO_TEST := $(COMMON_C_FILES_NO_TEST:src/common/%.c=build/common/%.o)
DEPS := $(COMMON_OBJ_FILES:.o=.d) $(MAIN_C_FILES:src/%.c=build/%.d)

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

.PHONY: %
%: build/%
	@$< $(INPUT)

.PRECIOUS: build/%
build/%: src/%.c src/common/common.h $(COMMON_OBJ_FILES_NO_TEST) | build
	gcc $(CFLAGS) $(CPPFLAGS) $^ -o $@

-include $(DEPS)

.PRECIOUS: build/common/%.o
build/common/%.o: src/common/%.c
	mkdir -p $(@D)
	gcc $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

##
# Tests

.PHONY: test
test: export AOC_TEST=1
test: build/11-run
test: build/common/astring_test-run
test: build/common/dynarray_test-run
test: build/common/queue_test-run
test: build/common/text_test-run

.PHONY: %-run
%-run: %
	@$<

.PRECIOUS: build/%_test
build/%_test: src/%_test.c src/%.h $(COMMON_OBJ_FILES_NO_TEST) | build
	gcc $(CFLAGS) $(CPPFLAGS) $^ $(LDLIBS) -o $@
