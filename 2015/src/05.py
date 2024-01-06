import fileinput
import re
import sys


V = "aeiou"


def part_one(lines):
    return len(list(filter(is_nice_part_one, lines)))


def part_two(lines):
    return len(list(filter(is_nice_part_two, lines)))


def is_nice_part_one(line):
    if re.search(r"ab|cd|pq|xy", line):
        return False
    vowels = filter(lambda x: x in V, line)
    return len(list(vowels)) >= 3 and has_two_consecutive_chars(line)


def is_nice_part_two(line):
    return repeat_and_between(line) and repeat_pair(line)


def has_two_consecutive_chars(line):
    i = 0
    n = len(line)
    while True:
        if i + 1 == n:
            return False
        if line[i] == line[i + 1]:
            return True
        i += 1


def repeat_and_between(line):
    i = 0
    n = len(line)
    while True:
        if i + 2 == n:
            return False
        if line[i] == line[i + 2]:
            return True
        i += 1


def repeat_pair(line):
    j = 0
    i = 2
    n = len(line)
    while True:
        if i + 1 >= n:
            j = j + 1
            i = j + 2
        if j + 3 >= n:
            return False
        if line[i] == line[j] and line[i + 1] == line[j + 1]:
            return True
        i += 1


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    print(part_one(lines))
    print(part_two(lines))
