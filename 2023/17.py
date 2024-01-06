from collections import deque
from heapq import heappush, heappop


HUGE = 999999999
MIN_TO_STOP = 4


def solve_1(matrix):
    return solve(matrix, neighbors)


def solve_2(matrix):
    return solve(matrix, ultra_neighbors, 4)


def solve(matrix, neighbors_fn, min_to_stop = 0):
    w = len(matrix[0])
    h = len(matrix)
    start_1 = (0, (0, 0, 0, 1, 0))  # ((i, j, di, dj, n), h)
    start_2 = (0, (0, 0, 1, 0, 0))  # ((i, j, di, dj, n), h)
    seen = {start_1: HUGE, start_2: HUGE}
    hq = [start_1, start_2]
    while hq:
        heat, node = heappop(hq)
        for n in neighbors_fn(w, h, node):
            ni = n[0]
            nj = n[1]
            new_heat = heat + matrix[ni][nj]
            if n in seen and seen[n] <= new_heat:
                continue
            if (not at_end(w, h, n) or min_to_stop <= n[4]):
                seen[n] = new_heat
                heappush(hq, (new_heat, n))
    return min([v for k, v in seen.items() if at_end(w, h, k)])


def at_end(w, h, n):
    return n[0] == h-1 and n[1] == w-1


def is_in(w, h, i, j):
    return (0 <= i < h) and (0 <= j < w)


def left(di, dj):
    assert 0 == di or 0 == dj
    if di == 0:
        return (-1, 0) if dj == 1 else (1, 0)
    else:
        return (0, 1) if di == 1 else (0, -1)


def right(di, dj):
    if di == 0:
        return (1, 0) if dj == 1 else (-1, 0)
    else:
        return (0, -1) if di == 1 else (0, 1)


def neighbors(w, h, node):
    i, j, di, dj, n = node
    result = []
    if n < 3 and is_in(w, h, i+di, j+dj):
        result.append((i+di, j+dj, di, dj, n+1))
    left_di, left_dj = left(di, dj)
    left_i = i+left_di
    left_j = j+left_dj
    if is_in(w, h, left_i, left_j):
        result.append((left_i, left_j, left_di, left_dj, 1))
    right_di, right_dj = right(di, dj)
    right_i = i+right_di
    right_j = j+right_dj
    if is_in(w, h, right_i, right_j):
        result.append((right_i, right_j, right_di, right_dj, 1))
    return result


def ultra_neighbors(w, h, node):
    i, j, di, dj, n = node
    if n < 4 and is_in(w, h, i+di, j+dj):
        return [(i+di, j+dj, di, dj, n+1)]

    result = []
    if n < 10 and is_in(w, h, i+di, j+dj):
        result.append((i+di, j+dj, di, dj, n+1))
    can_turn = ((0 < i < h-1) and (0 < j < w-1)) or MIN_TO_STOP <= n
    if can_turn:
        left_di, left_dj = left(di, dj)
        left_i = i+left_di
        left_j = j+left_dj
        if is_in(w, h, left_i, left_j):
            result.append((left_i, left_j, left_di, left_dj, 1))
        right_di, right_dj = right(di, dj)
        right_i = i+right_di
        right_j = j+right_dj
        if is_in(w, h, right_i, right_j):
            result.append((right_i, right_j, right_di, right_dj, 1))
    return result


ex = """2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"""
text = ex
# text = open(0).read()
numbers = [[int(c) for c in line] for line in text.splitlines()]
print(solve_1(numbers))
print(solve_2(numbers))
