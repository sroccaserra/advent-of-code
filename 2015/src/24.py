import fileinput
import sys
from itertools import combinations
from functools import reduce


def parse(lines):
    return [int(w) for w in lines]


def solve_1(numbers):
    return solve(numbers, 3)


def solve_2(numbers):
    return solve(numbers, 4)


def solve(numbers, nb_packages):
    possibles = find_possible_smallest(numbers, nb_packages)
    m = 2**63 - 1
    for ns in possibles:
        p = reduce((lambda x, y: x * y), ns)
        if p < m:
            m = p
    return m


def find_possible_smallest(numbers, nb_packages):
    target = sum(numbers)//nb_packages
    n = 1
    while True:
        result = []
        for ns in combinations(numbers, n):
            if sum(ns) == target:
                result.append(ns)
        if not [] == result:
            return result
        else:
            n += 1


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    numbers = parse(lines)
    print(solve_1(numbers))
    print(solve_2(numbers))
