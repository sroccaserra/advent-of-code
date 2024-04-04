SHELL=/bin/bash -euo pipefail

SRC_COMMON := $(wildcard src/common/*.c)
SRC_COMMON := $(filter-out $(wildcard src/common/*_test.c), $(SRC_COMMON))
OBJ_COMMON := $(SRC_COMMON:src/common/%.c=build/%.o)

CFLAGS := -std=c18 -Wall -Wextra -Wpedantic -Werror -g
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

.PRECIOUS: build/%.o
build/%.o: src/common/%.c | build
	cc $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

.PRECIOUS: build/%_test
build/%_test: $(OBJ_COMMON) build/%_test.o
	cc $(CFLAGS) $^ $(LDLIBS) -o $@

.PHONY: %_test
%_test: build/%_test | build
	@$<

.PRECIOUS: build/%
build/%: src/%.c $(OBJ_COMMON) | build
	gcc $(CFLAGS) -o $@ $^

.PHONY: %
%: build/%
	@$< src/$*.in

-include $(OBJ_COMMON:.o=.d)
