#!/usr/bin/env awk -f

function endg() {
    for (i in a) {
        part1++
        if (a[i] == np) part2++
        delete a[i]
    }
    np = 0
}

BEGIN { FS="" }
/./ { np++ ; for (i=1 ; i<= NF ; ++i) a[$i]++ }
/^$/ { endg() }
END { endg() ; print part1" "part2 }
