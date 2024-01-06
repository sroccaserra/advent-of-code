#!/usr/bin/env bash

gawk -f src/Day04.awk src/Day04.txt | rg byr | rg iyr | rg eyr | rg hgt | rg hcl | rg ecl | rg pid | wc -l
