from collections import defaultdict

def solve_1(lines):
    grid = make_grid(lines)
    w = len(lines[0])
    h = len(lines)
    result = 0
    for i in range(h):
        n = None
        is_connected = False
        for j in range(w):
            c = lines[i][j]
            if c.isdigit():
                # Start recording a number
                if n is None:
                    n = int(c)
                    is_connected = False
                else:
                    n = 10*n+int(c)
            if does_touch_sym(grid, i, j):
                is_connected = True

            # End recording a number
            next_j = j+1
            if n is not None and((w <= next_j) or not lines[i][next_j].isdigit()):
                if is_connected:
                    result += n
                n = None
    return result


def make_grid(lines):
    w = len(lines[0])
    h = len(lines)
    grid = defaultdict(lambda:'.')
    for i in range(h):
        for j in range(w):
            grid[(i, j)] = lines[i][j]
    return grid


def does_touch_sym(grid, i, j):
    incs = [(i, j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    result = False
    for inc in incs:
        target_i = i+inc[0]
        target_j = j+inc[1]
        c = grid[(target_i,target_j)]
        if c != '.' and not c.isdigit():
            return True
    return False


ex = """467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""[:-1].split('\n')


lines = ex
# lines = open(0).read()[:-1].split('\n')

print(solve_1(lines))
