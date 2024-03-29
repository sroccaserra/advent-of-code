SHELL=/bin/bash -euo pipefail

BUILD=build
SRC=src
LIB=lib

SRC_COMMON := $(wildcard src/common/*.c)
SRC_COMMON := $(filter-out $(wildcard src/common/*_test.c), $(SRC_COMMON))
OBJ_COMMON := $(SRC_COMMON:src/common/%.c=build/%.o)

CFLAGS := -std=c18 -Wall -Wextra -Wpedantic -Werror -g
CPPFLAGS := -Isrc/common -MMD -MP
LDLIBS := -lc

default: test_c

##
# Common

$(BUILD):
	mkdir -p $(BUILD)

.PHONY: clean
clean:
	rm -rf build/*

##
# Uxntal

.PRECIOUS: $(BUILD)/%.rom
$(BUILD)/%.rom: $(SRC)/%.tal $(BUILD) $(SRC)/common.tal $(SRC)/macros.tal $(LIB)/math32.tal
	uxnasm $< $@ 2>&1 | grep -v 'Unused label'

.PHONY: %_tal
%_tal: $(BUILD)/%.rom
	uxncli $<

.PHONY: %_talw
%_talw: $(BUILD)/%.rom
	uxnemu $<

##
# C++

.PRECIOUS: $(BUILD)/%_cpp
$(BUILD)/%_cpp: $(SRC)/%.cpp $(SRC)/common/common.hpp $(BUILD)
	g++ -Wall -Wpedantic -fsanitize=address,leak -std=c++20 -o $@ $<

.PHONY: %_cpp
%_cpp: $(BUILD)/%_cpp
	@$< src/$*.in

##
# C

.PRECIOUS: build/%.o
build/%.o: src/common/%.c | build
	cc $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

.PRECIOUS: build/%_test_c
build/%_test_c: $(OBJ_COMMON) build/%_test.o
	cc $(CFLAGS) $^ $(LDLIBS) -o $@

.PHONY: %_test_c
%_test_c: build/%_test_c | build
	@$<

.PHONY: test_c
test_c: dict_test_c treap_test_c

.PRECIOUS: build/%_c
build/%_c: src/%.c $(OBJ_COMMON) | build
	gcc $(CFLAGS) -o $@ $^

.PHONY: %_c
%_c: build/%_c
	@$< src/$*.in

-include $(OBJ_COMMON:.o=.d)

##
# Rust

.PRECIOUS: $(BUILD)/%_rs
$(BUILD)/%_rs: $(SRC)/%.rs $(SRC)/common/common.rs
	rustc -O -o $@ $<
	strip $@

.PHONY: %_rs
%_rs: $(BUILD)/%_rs
	@$< src/$*.in

##
# GNU Smalltalk

.PHONY: %_st
%_st:
	@gst --no-gc-message $(SRC)/common/common.st $(SRC)/$*.st -a $(SRC)/$*.in

##
# Java

.PRECIOUS: $(BUILD)/%.class
$(BUILD)/%.class: $(SRC)/%.java $(SRC)/common/*.java
	javac -d $(BUILD) $< $(SRC)/common/*.java

.PHONY: %_java
%_java: $(BUILD)/_%.class
	@java --class-path=$(BUILD) _$* src/$*.in

##
# Kotlin

.PRECIOUS: $(BUILD)/%.jar
$(BUILD)/%.jar: $(SRC)/%.kt $(SRC)/common/*.kt
	kotlinc $< $(SRC)/common/*.kt -d $@

.PHONY: %_kt
%_kt: $(BUILD)/%.jar
	@kotlin -classpath $(BUILD)/$*.jar _$*Kt src/$*.in

##
# x64 Assembly

.PRECIOUS: $(BUILD)/%_s
$(BUILD)/%_s: $(SRC)/%.s $(SRC)/common/common.s
	# gcc -L . -pie -o $@ $<
	# gcc -no-pie -nostdlib -o $@ $<
	as -o $(BUILD)/$*.o $<
	ld -o $@ $(BUILD)/$*.o

.PHONY: %_s
%_s: $(BUILD)/%_s
	@$< src/$*.in

.PHONY: %_sd
%_sd: $(BUILD)/%_s
	gdb -ex 'br *_start' -ex start -ex 'br halt' -ex 'layout asm' -ex 'tui reg general' -ex 'focus cmd' --args $< src/$*.in

##
# Go (for perf tests only, go run is just as good)

.PRECIOUS: $(BUILD)/%_go
$(BUILD)/%_go: $(SRC)/%.go $(SRC)/common/common.go
	go build -o $@ $<

.PHONY: %_go
%_go: $(BUILD)/%_go
	@$< src/$*.in
