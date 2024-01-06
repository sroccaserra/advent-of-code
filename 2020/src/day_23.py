import fileinput
import sys


def part_one(numbers):
    circle = init_circle_1(numbers, len(numbers))
    current = numbers[0]
    for i in range(0, 100):
        current = step(circle, current)
    return circle


def init_circle_1(numbers, size):
    circle = [None]*(size)
    for i in range(0, len(numbers) - 1):
        set_next(circle, numbers[i], numbers[i+1])
    set_next(circle, numbers[size-1], numbers[0])
    return circle


def part_two(numbers):
    circle = init_circle_2(numbers, 1000000)
    current = numbers[0]
    for i in range(0, 10000000):
        current = step(circle, current)
    return circle


def init_circle_2(numbers, size):
    circle = [None]*(size)
    n = len(numbers)
    for i in range(0, n - 1):
        set_next(circle, numbers[i], numbers[i+1])
    set_next(circle, numbers[n-1], n+1)
    for i in range(n+1, size):
        set_next(circle, i, i+1)
    set_next(circle, size, numbers[0])
    return circle


def step(circle, current):
    cup_1 = get_next(circle, current)
    cup_2 = get_next(circle, cup_1)
    cup_3 = get_next(circle, cup_2)

    next_current = get_next(circle, cup_3)

    dest = current - 1
    if dest <= 0:
        dest = len(circle)
    while dest in [cup_1, cup_2, cup_3]:
        dest -= 1
        if dest <= 0:
            dest = len(circle)

    after_dest = get_next(circle, dest)

    set_next(circle, current, next_current)
    set_next(circle, dest, cup_1)
    set_next(circle, cup_3, after_dest)

    return next_current


def get_next(circle, n):
    return circle[n-1]


def set_next(circle, i, n):
    circle[i-1] = n


def print_circle(circle, current):
    n = current
    for i in range(0, 9):
        print(n, end=' ')
        n = get_next(circle, n)
    print()


if __name__ == '__main__' and not sys.flags.interactive:
    [line] = [l.strip() for l in fileinput.input()]
    numbers = [int(x) for x in list(line)]
    print(numbers)
    circle = part_one(numbers)
    print_circle(circle, 1)
    circle = part_two(numbers)
    n_1 = get_next(circle, 1)
    n_2 = get_next(circle, n_1)
    print(n_1*n_2)
