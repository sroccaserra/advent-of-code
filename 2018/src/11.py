import sys
import fileinput
from collections import defaultdict


def solve_1(sn):
    table = summed_area_table(sn)
    _, x, y = best(table, 3)
    return x, y


def solve_2(power_levels):
    table = summed_area_table(sn)
    max_total_level = 0
    corner_x = 0
    corner_y = 0
    size = 0
    for s in range(1, 301):
        print(s, end="\r")
        level, x, y = best(table, s)
        if level > max_total_level:
            max_total_level = level
            corner_x = x
            corner_y = y
            size = s

    return corner_x, corner_y, size


def best(t, s):
    max_total_level = 0
    corner_x = 0
    corner_y = 0
    for y in range(1, 301-s):
        for x in range(1, 301-s):
            level = t[(x-1,y-1)]+t[(x-1+s, y-1+s)]-t[(x-1,y-1+s)]-t[(x-1+s, y-1)]
            if level > max_total_level:
                max_total_level = level
                corner_x = x
                corner_y = y
                size = s
    return max_total_level, corner_x, corner_y


def summed_area_table(sn):
    t = defaultdict(int)
    for y in range(1, 301):
        for x in range(1, 301):
            level = power_level(sn, x, y)
            t[(x,y)] = level+t[(x,y-1)]+t[(x-1,y)]-t[(x-1,y-1)]
    return t


def power_level(sn, x, y):
    rack_id = x + 10
    return ((rack_id*(rack_id*y + sn))//100) % 10 - 5


if __name__ == '__main__' and not sys.flags.interactive:
    sn = int(next(fileinput.input()).strip())
    print(solve_1(sn))
    print(solve_2(sn))
