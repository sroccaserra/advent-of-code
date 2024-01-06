from collections import defaultdict


def solve_1(grid):
    return solve(grid)


def solve_2(grid):
    result = 0
    w = len(grid[0])
    h = len(grid)
    for i in range(h):
        result = max(result, solve(grid, (complex(i, 0), 1j)))
        result = max(result, solve(grid, (complex(i, w-1), -1j)))
    for j in range(w):
        result = max(result, solve(grid, (complex(0, j), 1)))
        result = max(result, solve(grid, (complex(h-1, j), -1)))
    return result


def solve(grid, start= (0j, 1j)):
    s = [start]
    seen = defaultdict(list)
    seen[start[0]].append(start[1])
    while s:
        pos, d = s.pop()
        dest = pos + d
        if is_out(grid, dest) or d in seen[dest]:
            continue
        seen[dest].append(d)
        c = at(grid, dest)
        if c == '|' and d in [-1j, 1j]:
            s.append((dest, 1))
            s.append((dest, -1))
            continue
        if c == '-' and d in [-1, 1]:
            s.append((dest, 1j))
            s.append((dest, -1j))
            continue
        if (c == '/' and d.real == 0) or (c == '\\' and d.imag == 0):
            s.append((dest, d*1j))
            continue
        if (c == '/' and d.imag == 0) or (c == '\\' and d.real == 0):
            s.append((dest, d*-1j))
            continue
        if c == '.' or c == '|' or c == '-':
            s.append((dest, d))
    return len(seen)


def show(grid, seen={}):
    print()
    w = len(grid[0])
    h = len(grid)
    for i in range(h):
        line = grid[i]
        for j in range(w):
            c = '#' if complex(i, j) in seen else line[j]
            print(c, end='')
        print()


def at(grid, pos):
    return grid[int(pos.real)][int(pos.imag)]


def is_out(grid, pos):
    w = len(grid[0])
    h = len(grid)
    i, j = pos.real, pos.imag
    return i < 0 or j < 0 or h <= i or w <= j


def is_in(grid, pos):
    return not is_out(grid, pos)


ex = '''.|...\....
|.-.\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....
'''
text = ex
# text = open(0).read()
lines = text.splitlines()

print(solve_1(lines))
print(solve_2(lines))
