from fileinput import input
from collections import deque
from copy import deepcopy


def solve_1(grid):
    for _ in range(10):
        grid = step(grid)
        RULES.rotate(-1)
    return count_empty(grid)


def solve_2(grid):
    result = 0
    while True:
        result += 1
        next_grid = step(grid)
        if grid == next_grid:
            break
        grid = next_grid
        RULES.rotate(-1)
    return result


def step(grid):
    moves = {}
    known = set()
    refused = set()
    for (x, y) in grid:
        proposal = propose(grid, x, y)
        if proposal is None:
            moves[(x, y)] = (x, y)
            continue
        moves[(x, y)] = proposal
        if proposal in known:
            refused.add(proposal)
        else:
            known.add(proposal)
    result = set()
    for (x, y) in grid:
        proposed = moves[(x, y)]
        if proposed in refused:
            result.add((x, y))
        else:
            result.add(proposed)
    return result


def count_empty(grid):
    xs = [x for (x, _) in grid]
    ys = [y for (_, y) in grid]
    result = 0
    for y in range(min(ys), max(ys)+1):
        for x in range(min(xs), max(xs)+1):
            if (x, y) not in grid:
                result += 1
    return result


def dump(grid):
    xs = [x for (x, _) in grid]
    ys = [y for (_, y) in grid]
    result = 0
    for y in range(min(ys), max(ys)+1):
        for x in range(min(xs), max(xs)+1):
            if (x, y) in grid:
                print('#', end='')
            else:
                print('.', end='')
        print()
    print()


def rule_a(grid, x, y):
    up = y-1
    west = x-1
    east = x+1
    if (west, up) not in grid and (x, up) not in grid and (east, up) not in grid:
        return (x, up)


def rule_b(grid, x, y):
    west = x-1
    east = x+1
    down = y+1
    if (west, down) not in grid and (x, down) not in grid and (east, down) not in grid:
        return (x, down)


def rule_c(grid, x, y):
    up = y-1
    west = x-1
    down = y+1
    if (west, up) not in grid and (west, y) not in grid and (west, down) not in grid:
        return (west, y)


def rule_d(grid, x, y):
    up = y-1
    east = x+1
    down = y+1
    if (east, up) not in grid and (east, y) not in grid and (east, down) not in grid:
        return (east, y)


RULES = deque([rule_a, rule_b, rule_c, rule_d])


def propose(grid, x, y):
    up = y-1
    west = x-1
    east = x+1
    down = y+1
    if (x, up) not in grid and (x, down) not in grid and (west, y) not in grid and (east, y) not in grid and (west, up) not in grid and (east, up) not in grid and (west, down) not in grid and (east, down) not in grid:
        return None
    for rule in RULES:
        res = rule(grid, x, y)
        if res:
            return res
    return None


lines = [line.strip() for line in input()]
grid = set()
w = len(lines[0])
h = len(lines)
for y in range(h):
    line = lines[y]
    for x in range(w):
        c = line[x]
        if c == '#':
            grid.add((x, y))
print(solve_1(grid))
RULES = deque([rule_a, rule_b, rule_c, rule_d])
print(solve_2(grid))
