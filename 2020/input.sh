#!/usr/bin/env bash

n=$(printf %02d "$1")

http --session=aoc "https://adventofcode.com/2020/day/$1/input" > "src/Day$n.txt"
less "src/Day$n.txt"
echo
wc "src/Day$n.txt"
