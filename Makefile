SHELL=/bin/bash -euo pipefail

BUILD=build
SRC=src
LIB=lib

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
$(BUILD)/%_cpp: $(SRC)/%.cpp $(SRC)/common/common.h
	g++ $< -o $@ --std=c++20

.PHONY: %_cpp
%_cpp: $(BUILD)/%_cpp
	@$< src/$*.in
