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
    # print_cavern(cavern, level, rock, rock_x, rock_y)


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


line = next(fileinput.input()).strip()
commands = [{'<': -1, '>': 1}[c] for c in line]
print(solve_1(commands))
