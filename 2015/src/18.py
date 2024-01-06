import fileinput
import sys
from types import SimpleNamespace
from operator import add


def parse(lines):
    w = len(lines[0])
    h = len(lines)
    on = dict()
    for i in range(w):
        for j in range(h):
            if lines[j][i] == "#":
                on[(i, j)] = True
    return SimpleNamespace(on=on, w=w, h=h)


def solve_1(grid):
    for _ in range(100):
        grid = step(grid)
    return len(grid.on)


def solve_2(grid):
    lightCorners(grid)
    for _ in range(100):
        grid = step(grid)
        lightCorners(grid)
    return len(grid.on)


def step(grid):
    result = SimpleNamespace(on=dict(), w=grid.w, h=grid.h)
    for i in range(grid.w):
        for j in range(grid.h):
            if nextState(grid.on, i, j):
                result.on[(i, j)] = True

    return result


def nextState(on, i, j):
    n = onNeighborCount(on, i, j)
    isOn = on.get((i, j))
    if isOn:
        return n == 2 or n == 3
    else:
        return n == 3


def onNeighborCount(on, i, j):
    result = 0
    for incs in [
            (-1, -1), (0, -1), (1, -1),
            (-1, 0),           (1, 0),
            (-1, 1),  (0, 1),  (1, 1),
            ]:
        neighbor = tuple(map(add, (i, j), incs))
        if on.get(neighbor):
            result += 1
    return result


def lightCorners(grid):
    for coords in [(0, 0), (grid.w-1, 0), (0, grid.h-1), (grid.w-1, grid.h-1)]:
        grid.on[coords] = True


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    grid = parse(lines)
    print(solve_1(grid))
    print(solve_2(grid))
