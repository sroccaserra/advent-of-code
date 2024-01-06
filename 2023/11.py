from collections import defaultdict


def solve(exp, lines):
    w = len(lines[0])
    h = len(lines)
    col_increments = [exp-1 for _ in range(w)]
    row_increments = [exp-1 for _ in range(h)]
    for i in range(h):
        line = lines[i]
        for j in range(w):
            c = line[j]
            if c == '#':
                row_increments[i] = 0
                col_increments[j] = 0

    inc_i = 0
    max_j = 0
    max_i = 0
    galaxies = []
    for i in range(h):
        line = lines[i]
        inc_j = 0
        inc_i += row_increments[i]
        max_i = max(max_i, i+inc_i)
        for j in range(w):
            c = line[j]
            inc_j += col_increments[j]
            max_j = max(max_j, j+inc_j)
            if c == '#':
                pos = (i + inc_i, j + inc_j)
                galaxies.append(pos)

    result = 0
    seen = set()
    for i in range(len(galaxies)):
        for j in range(len(galaxies)):
            if (i, j) not in seen:
                result += path_len(galaxies[i], galaxies[j])
                seen.add((i, j))
                seen.add((j, i))

    return result


def path_len(a, b):
    xa, ya = a
    xb, yb = b
    return abs(xb-xa)+abs(yb-ya)


ex = """...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"""
text = ex
# text = open(0).read()
lines = text.split('\n')[:-1]
print(solve(2, lines))
print(solve(10, lines))
# print(solve(1000000, lines))
