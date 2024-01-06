from collections import defaultdict


def solve_1(lines):
    grid = build_grid(lines)
    w = len(lines[0])
    h = len(lines)
    for i in range(h):
        for j in range(w):
            if grid[i, j] == 'O':
                fall(grid, -1, 0, i, j)
    return count(grid, w, h)


def solve_2(lines):
    grid = build_grid(lines)
    w = len(lines[0])
    h = len(lines)
    seen_at = {}
    previous_diff = -99
    vals = []
    cycle_len = -99
    search_range = 200
    for i in range(search_range):
        cycle(grid, w, h)
        k = count(grid, w, h)
        vals.append(k)
        if k in seen_at:
            diff = i-seen_at[k]
            if diff == previous_diff:
                cycle_len = diff
            previous_diff = diff
        seen_at[k] = i
    cycling_vals = []
    for i in reversed(range(cycle_len)):
        cycling_vals.append(vals[-i-1])
    return cycling_vals[(1000000000-search_range-1)%cycle_len]


def count(grid, w, h):
    result = 0
    for i in range(h):
        for j in range(w):
            if grid[i,j] == 'O':
                result += w-i
    return result


def build_grid(lines):
    grid = defaultdict(lambda: '#')
    w = len(lines[0])
    h = len(lines)
    for i in range(h):
        line = lines[i]
        for j in range(w):
            grid[i,j] = line[j]
    return grid


def fall(grid, vec_i, vec_j, i, j):
    grid[i,j] = '.'
    while grid[i+vec_i, j+vec_j] == '.':
        i += vec_i
        j += vec_j
    grid[i, j] = 'O'


def cycle(grid, w, h):
    for i in range(h):
        for j in range(w):
            if grid[i, j] == 'O':
                fall(grid, -1, 0, i, j)
    for j in range(w):
        for i in range(h):
            if grid[i, j] == 'O':
                fall(grid, 0, -1, i, j)
    for i in reversed(range(h)):
        for j in range(w):
            if grid[i, j] == 'O':
                fall(grid, 1, 0, i, j)
    for i in range(h):
        for j in reversed(range(w)):
            if grid[i, j] == 'O':
                fall(grid, 0, 1, i, j)


ex = """O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""
text = ex
# text = open(0).read()
lines = text.split('\n')[:-1]
print(solve_1(lines))
print(solve_2(lines))
