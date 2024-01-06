import fileinput
from copy import deepcopy
from math import copysign


def solve_1(grid):
    previous = {}
    max_y = 0
    for (_, y) in grid.keys():
        if y > max_y:
            max_y = y
    while grid != previous:
        previous = deepcopy(grid)
        drop_grain(grid, max_y)
    result = 0
    for p in grid:
        if grid[p] == 'o':
            result += 1
    return result


def solve_2(grid):
    max_y = 0
    for (_, y) in grid.keys():
        if y > max_y:
            max_y = y
    count = 0
    while (500, 0) not in grid:
        count += 1
        drop_grain_with_floor(grid, max_y+2)
    result = 0
    for p in grid:
        if grid[p] == 'o':
            result += 1
    return result


def drop_grain(grid, max_y):
    grain = (500, 0)
    dest = next_free_space(grid, grain)

    while dest is not None:
        if dest[1] > max_y:
            return
        grain = dest
        dest = next_free_space(grid, grain)
    grid[grain] = 'o'


def drop_grain_with_floor(grid, floor):
    grain = (500, 0)
    dest = next_free_space(grid, grain)

    while dest is not None and dest[1] < floor:
        grain = dest
        dest = next_free_space(grid, grain)
    grid[grain] = 'o'


def next_free_space(grid, grain):
    x, y = grain
    candidates = [(x, y+1), (x-1, y+1), (x+1, y+1)]
    for c in candidates:
        if c not in grid:
            return c


def print_grid(grid, x, y, w, h):
    for i in range(y,y+h):
        for j in range(x,x+w):
            if (j, i) in grid:
                print(grid[(j,i)], end='')
            else:
                print('.', end='')
        print()


segments = [[tuple([int(s) for s in ss.split(',')]) for ss in line.strip().split(' -> ')] for line in fileinput.input()]
grid = {}
for segment in segments:
    for i in range(len(segment)-1):
        x1, y1 = segment[i]
        x2, y2 = segment[i+1]
        if x1 == x2:
            dx = 0
        else:
            dx = int(copysign(1, x2-x1))
        if y1 == y2:
            dy = 0
        else:
            dy = int(copysign(1, y2-y1))
        for j in range(max(abs(x2-x1), abs(y2-y1))+1):
            grid[(x1+j*dx, y1+j*dy)] = '#'
print(solve_1(grid))
print(solve_2(grid))
