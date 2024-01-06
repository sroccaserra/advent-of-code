#!/usr/bin/env bash

in=1321131112

for n in $(seq 1 50)
do
  in=$(echo "$in" | fold -w1 | uniq -c | tr -d '\n ')
  printf "%s: " "$n"
  printf "%s" "$in" | wc -c
done
