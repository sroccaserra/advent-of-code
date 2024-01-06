import fileinput
from itertools import cycle


ROCKS = [
        [
            "@@@@"],

        [
            '.@.',
            '@@@',
            '.@.' ],
        [
            '..@',
            '..@',
            '@@@'],
        [
            '@',
            '@',
            '@',
            '@'],
        [
            '@@',
            '@@']
        ]

CAVE_W = 7

W = 1
H = 2
DICT = 3


def solve_1(commands):
    command_it = cycle(commands)
    rock_it = make_rock_iterator()
    level = 0
    cavern = make_cavern()
    for _ in range(2022):
        rock = next(rock_it)
        fall(cavern, level, command_it, rock)
        for (x, y) in cavern.keys():
            if cavern[(x,y)] == '#':
                if level < y:
                    level = y
        for y in range(level+3+4):
            cavern[(-1, y)] = '|'
            cavern[(CAVE_W, y)] = '|'
    return level


def solve_2(commands):
    target = 1_000_000_000_000
    command_it = cycle(commands)
    rock_it = make_rock_iterator()
    level = 0
    previous_level = 0
    cavern = make_cavern()
    d_levels = []
    levels = []
    cycle_maybe = None
    for _ in range(target):
        rock = next(rock_it)

        fall(cavern, level, command_it, rock)
        for (x, y) in cavern.keys():
            if cavern[(x,y)] == '#':
                if level < y:
                    level = y
        for y in range(level+3+4):
            cavern[(-1, y)] = '|'
            cavern[(CAVE_W, y)] = '|'

        levels.append(level)
        d_level = level - previous_level
        d_levels.append(d_level)
        cycle_maybe = find_largest_cycle(d_levels)
        if cycle_maybe is not None and cycle_maybe[2] > 30:
            break
        previous_level = level
    assert cycle_maybe is not None
    last_cycle_start = cycle_maybe[0]+1
    last_cycle_end = cycle_maybe[1]
    cycle_size = cycle_maybe[2]
    missing_rocks = target - cycle_maybe[1]
    missing_cycles = missing_rocks // cycle_size
    by_cycle = levels[last_cycle_end]-levels[last_cycle_start-1]
    remainder = missing_rocks % cycle_size
    target_level = level + missing_cycles*by_cycle
    d_cycle = d_levels[last_cycle_start:last_cycle_end+1]
    for i in range(remainder-1):
        d_level = d_cycle[i]
        target_level += d_level

    return target_level


def make_cavern():
    cavern = {}
    for i in range(7):
        cavern[(i, 0)] = '-'
    for i in range(3 + 4):
        cavern[(-1, i)] = '|'
        cavern[(CAVE_W, i)] = '|'
    cavern[(-1, 0)] = '+'
    cavern[(CAVE_W, 0)] = '+'
    return cavern


def fall(cavern, level, command_it, rock):
    rock_y = level + 4
    rock_x = 2

    while True:
        command = next(command_it)
        next_x = rock_x + command
        if not intersects(cavern, rock, next_x, rock_y):
            rock_x = next_x
        next_y = rock_y - 1
        if intersects(cavern, rock, rock_x, next_y):
            break
        rock_y = next_y
    for (x, y) in rock[DICT].keys():
        cavern[(x+rock_x, y+rock_y)] = '#'


def intersects(cavern, rock, rock_x, rock_y):
    for (x, y) in rock[DICT].keys():
        if (x+rock_x, y+rock_y) in cavern:
            return True
    return False


def print_cavern(cavern, level, rock, rock_x, rock_y):
    for y in range(max(rock_y+rock[H], level), -1, -1):
        for x in range(-1, CAVE_W + 1):
            if (x, y) in cavern:
                print(cavern[(x, y)], end='')
            elif (x-rock_x, y - rock_y) in rock[DICT]:
                print(rock[DICT][(x-rock_x, y-rock_y)], end='')
            else:
                print('.', end='')
        print('')


def make_rock_iterator():
    n = 0
    tuples = []
    for shape in ROCKS:
        tuples.append(rock_tuple(shape))
    while True:
        yield tuples[n % len(tuples)]
        n += 1


def rock_tuple(rock_shape):
    w = len(rock_shape[0])
    h = len(rock_shape)
    rock_dict = {}
    for y in range(h):
        for x in range(w):
            if rock_shape[h-1-y][x] == '@':
                rock_dict[(x, y)] = '@'
    return (rock_shape, w, h, rock_dict)


def find_largest_cycle(v):
    last = len(v) - 1
    m = last - 1
    found = None
    while v[last] != v[m]:
        m -= 1
    while m + 1 >= len(v)//2:
        same = True
        for i in range(1, last-m):
            if not v[last-i] == v[m-i]:
                same = False
                break
        if same == True:
            found = (m, last, last - m)
        m -= 1
        while 0 < m and v[last] != v[m]:
            m -= 1
    return found


line = next(fileinput.input()).strip()
commands = [{'<': -1, '>': 1}[c] for c in line]
print(solve_1(commands))
print(solve_2(commands))
