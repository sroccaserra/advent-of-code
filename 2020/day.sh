#!/usr/bin/env bash

n=$(printf %02d "$1")

if test "$2" != "test"
then
    sed "s/DayXX/Day$n/" "src/DayXX.hs" > "src/Day${n}.hs"
else
    sed "s/DayXX/Day$n/" "test/DayXXSpec.hs" > "test/Day${n}Spec.hs"
fi

stack build --only-dependencies
