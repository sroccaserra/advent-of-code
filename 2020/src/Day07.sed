#!/usr/bin/env sed -f

s/ bags contain (no other)?/:/g
s/ bags?|\.//g
s/, /,/g
s/([a-z]) ([a-z])/\1_\2/g
