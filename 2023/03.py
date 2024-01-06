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


def solve_2(lines):
    grid = make_grid(lines)
    stars = []
    for k,v in grid.items():
        if v == '*':
            stars.append(k)
    result = 0
    for star_pos in stars:
        i,j = star_pos
        numbers = find_numbers_around(grid, i, j)
        if len(numbers) == 2:
            result += numbers[0]*numbers[1]
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


def find_numbers_around(grid, i, j):
    incs = [(i, j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    result = set()
    for inc in incs:
        n = find_number_at(grid, i+inc[0], j+inc[1])
        if n is not None:
            result.add(n)
    return list(result)


def find_number_at(grid, i, j):
    c = grid[(i, j)]
    if not c.isdigit():
        return None
    # step back
    k = 0
    while grid[(i, j+k-1)].isdigit():
        k -= 1
    # count
    n = 0
    while grid[(i, j+k)].isdigit():
        n = 10*n + int(grid[(i, j+k)])
        k += 1
    return n


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
print(solve_2(lines))
