from fileinput import input
from collections import deque


def solve_1():
    return trip((1, 0), (W-2, H-2), 0)


def solve_2():
    t_1 = PART_ONE
    t_2 = trip((W-2, H-1), (1, 1), t_1)
    t_3 = trip((1, 0), (W-2, H-2), t_1+t_2)
    return t_1 + t_2 + t_3


def trip(start, dest, t_0):
    start_state = (start, 0)
    q = deque([start_state])
    seen = set([start_state])
    while q:
        ((x, y), d) = q.popleft()
        if (x, y) == dest:
            return d+1
        ns = neighbors(get_blizzards(d+1+t_0), x, y)
        for n in ns:
            candidate = (n, d+1)
            if candidate in seen:
                continue
            seen.add(candidate)
            q.append(candidate)
    assert False


def neighbors(blizzards, x, y):
    blocked = set([pos for (pos, _, _) in blizzards])
    result = []
    for n in ((x, y), (x+1, y), (x-1, y), (x, y+1), (x, y-1)):
        if n == (1, 0) or n == (W-2, H-1):
            result.append(n)
        elif n not in blocked and (0 < n[0] < W-1) and (0 < n[1] < H - 1):
            result.append(n)
    return result


def get_blizzards(n):
    while len(BLIZZARDS) < n+2:
        bs_last = BLIZZARDS[-1]
        BLIZZARDS.append(blow(bs_last))
    return BLIZZARDS[n]


def blow(blizzards):
    result = []
    for ((x, y), (dx, dy), c) in blizzards:
        x = x + dx
        if W-1 <= x:
            x = 1
        if x <= 0:
            x = W-2
        y = y + dy
        if H-1 <= y:
            y = 1
        if y <= 0:
            y = H-2
        result.append(((x, y), (dx, dy), c))
    return tuple(result)


DIRS = {'>': (1, 0), 'v': (0, 1), '<': (-1, 0), '^': (0, -1)}


def print_blizzards(blizzards, w, h):
    found = set()
    for y in range(h):
        for x in range(w):
            done = False
            for b in blizzards:
                if (x, y) == b[0] and (x, y) not in found:
                    print(b[2], end='')
                    found.add((x, y))
                    done = True
                    continue
            if not done:
                print('.', end='')
        print()
    print()


lines = [line.strip() for line in input()]
blizzard_list = []
W = len(lines[0])
H = len(lines)
for y in range(H):
    line = lines[y]
    for x in range(W):
        c = line[x]
        if c in '>v<^':
            blizzard_list.append(((x, y), DIRS[c], c))
BLIZZARDS = [tuple(blizzard_list)]
PART_ONE = solve_1()
print(PART_ONE)
print(solve_2())
