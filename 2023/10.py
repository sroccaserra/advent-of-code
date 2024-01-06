from collections import defaultdict, deque


def solve_1(grid):
    start = None
    for k, v in grid.items():
        if v == 'S':
            start = k
            break
    dists = {start: 0}
    q = deque([start])
    result = 0
    while q:
        pos = q.popleft()
        d = dists[pos]
        for n in neighbors(grid, pos):
            if n in dists:
                continue
            q.append(n)
            dists[n] = d+1
            result = max(result, d+1)
    return result


def solve_2(grid):
    start = None
    for k, v in grid.items():
        if v == 'S':
            start = k
            break
    dists = {start: 0}
    s = [start]
    polygon = [start]
    while s:
        pos = s.pop()
        d = dists[pos]
        first_found = False
        for n in neighbors(grid, pos):
            if first_found:
                continue
            if n in dists:
                continue
            first_found = True
            s.append(n)
            polygon.append(n)
            dists[n] = d+1
    for k, v in grid.items():
        if k not in dists:
            grid[k] = '.'
        else:
            grid[k] = str(dists[k]%10)
    polygon.append(start)
    result = 0
    for k, v in grid.items():
        if v == '.' and is_inside(polygon, k):
            result += 1
    return result


def neighbors(grid, pos):
    i, j = pos
    result = []
    c = grid[(i, j)]
    if c in 'S-FL' and grid[(i, j+1)] in '-J7':
        result.append((i, j+1))
    if c in 'S7J-' and grid[(i, j-1)] in 'FL-':
        result.append((i, j-1))
    if c in 'SF7|' and grid[(i+1, j)] in 'JL|':
        result.append((i+1, j))
    if c in 'SLJ|' and grid[(i-1, j)] in 'F7|':
        result.append((i-1, j))
    return result


def is_inside(polygon, point):
    x, y = point
    nb_right = 0
    for i in range(len(polygon)-1):
        x1, y1 = polygon[i]
        x2, y2 = polygon[i+1]
        if y1 == y2:
            continue
        assert x1 == x2
        if min(y1, y2) <= y < max(y1, y2):
            assert x != x1
            if x < x1:
                nb_right += 1
    return nb_right %2 == 1


ex = """-L|F7
7S-7|
L|7||
-L-J|
L|-JF
"""
ex = """...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""
text = ex
# text = open(0).read()
lines = text.split('\n')[:-1]
grid = defaultdict(lambda: '.')
w = len(lines[0])
h = len(lines)
for i in range(h):
    line = lines[i]
    for j in range(w):
        grid[(i, j)] = line[j]
print(solve_1(grid))
print(solve_2(grid))

exit(0)
for i in range(h):
    line = lines[i]
    for j in range(w):
        print(grid[(i, j)], end='')
    print()
