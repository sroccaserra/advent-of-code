#!/usr/bin/env bash

re_1='children: 3|cats: 7|samoyeds: 2|pomeranians: 3|akitas: 0|vizslas: 0|goldfish: 5|trees: 3|cars: 2|perfumes: 1\b'
re_2='children: 3|cats: (8|9|10)|samoyeds: 2|pomeranians: (0|1|2)\b|akitas: 0|vizslas: 0|goldfish: (0|1|2|3|4)\b|trees: (4|5|6|7|8|9|10)|cars: 2|perfumes: 1\b'
rg "$re_2" src/16.txt
