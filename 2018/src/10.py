import sys
import fileinput
import re


W = 55
H = 9


def solve(data):
    n = 0
    last_width = 100000000
    while True:
        data = step(data)
        r = rect(data)

        width = r[2]
        if width > last_width:
            break
        last_width = width

        n += 1
        a_x = W/r[2]
        b_x = -r[0]*a_x
        a_y = H/r[3]
        b_y = -r[1]*a_y
        points = [screen_coords(d[0], a_x, b_x, a_y, b_y) for d in data]
        grid = [['.' for _ in range(W+1)] for _ in range(H+1)]
        for p in points:
            i = round(p[1])
            j = round(p[0])
            grid[i][j] = '#'
        if 0 == n % 1000:
            print(n)

    print(n)
    print_grid(grid)


def rect(data):
    xs = [d[0][0] for d in data]
    ys = [d[0][1] for d in data]

    min_x = min(xs)
    max_x = max(xs)
    min_y = min(ys)
    max_y = max(ys)

    return (min_x, min_y, max_x - min_x, max_y - min_y)


def screen_coords(p, a_x, b_x, a_y, b_y):
    x = p[0]
    y = p[1]
    return (a_x*x+b_x,a_y*y+b_y)


def step(data):
    return [step_d(d) for d in data]


def step_d(d):
    p = d[0]
    v = d[1]
    return ((p[0] + v[0], p[1] + v[1]), (v[0], v[1]))


def print_grid(g):
    lines = [''.join(row) for row in g]
    for line in lines:
        print(line)


def parse_pos(line):
    search = re.search('position=< *([\-0-9]*), *([\-0-9]*)', line)
    return (int(search.group(1)), int(search.group(2)))


def parse_vel(line):
    search = re.search('velocity=< *([\-0-9]*), *([\-0-9]*)', line)
    return (int(search.group(1)), int(search.group(2)))


if __name__ == '__main__' and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    data = [(parse_pos(line), parse_vel(line)) for line in lines]
    solve(data)
