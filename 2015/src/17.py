import fileinput
import sys
from itertools import chain, combinations


def parse(lines):
    return [int(line) for line in lines]


def solve_1(containers):
    n = 0
    for subsequence in powerset(containers):
        if sum(subsequence) == 150:
            n += 1
    return n


def solve_2(containers):
    n = 0
    known_minimum = len(containers)
    for subsequence in powerset(containers):
        if sum(subsequence) == 150:
            subset_length = len(subsequence)
            if subset_length < known_minimum:
                n = 0
                known_minimum = subset_length
            if subset_length == known_minimum:
                n += 1
    return n


# Implementation from https://docs.python.org/3/library/itertools.html
def powerset(iterable):
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    containers = parse(lines)
    print(solve_1(containers))
    print(solve_2(containers))
