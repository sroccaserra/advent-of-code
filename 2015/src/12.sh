#!/usr/bin/env bash

tr '{}[], ":abcdefghiklmnopqrstuvwxyz' ' ' <src/12.txt \
    | tr -s ' ' \
    | tr ' ' '\n' \
    | awk '{ s += $1 } END { print s }'

tr '{}[], ":abcdefghiklmnopqrstuvwxyz' ' ' <src/12_no_red.txt \
    | tr -s ' ' \
    | tr ' ' '\n' \
    | awk '{ s += $1 } END { print s }'
