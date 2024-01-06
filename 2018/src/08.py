import sys
import fileinput

from collections import deque

def solve_part_one(ns):
    q = deque(ns)
    return walk_tree_1(q)


def solve_part_two(ns):
    q = deque(ns)
    return walk_tree_2(q)


#  2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
#  A----------------------------------
#      B----------- C-----------
#                       D-----


def walk_tree_1(q):
    c = q.popleft()
    n = q.popleft()
    s = 0
    for _ in range(c):
        s += walk_tree_1(q)
    for _ in range(n):
        s += q.popleft()
    return s


def walk_tree_2(q):
    c = q.popleft()
    n = q.popleft()
    s = 0
    children = []
    for _ in range(c):
        children.append(walk_tree_2(q))
    for i in range(n):
        if c == 0:
            s += q.popleft()
        else:
            i = q.popleft()
            if 0 < i and i <= len(children):
                s += children[i-1]
    return s


if __name__ == '__main__' and not sys.flags.interactive:
    line = next(fileinput.input())
    ns = [int(w) for w in line.split()]
    print(solve_part_one(ns))
    print(solve_part_two(ns))
