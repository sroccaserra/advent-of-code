from functools import reduce
import fileinput
import re
import sys


def part_one(rules, values):
    regex = reduce_rules(rules)+'$'
    matches = list(filter(lambda v: re.match(regex, v), values))
    return len(matches)


def reduce_rules(rules):
    while len(rules) > 1:
        rules = step(rules)
    return rules['0'].replace(' ', '')


def step(rules):
    solved = find_solved(rules)
    unsolved = find_unsolved(rules)
    return {k: solve(v, solved) for k, v in unsolved.items()}


def find_solved(d):
    return {k: v for k, v in d.items() if is_solved(v)}


def find_unsolved(d):
    return {k: v for k, v in d.items() if not is_solved(v)}


def solve(v, solved):
    return reduce(lambda s, k: replace_rule(k, solved[k], s), solved, v)


def replace_rule(k, v, s):
    return re.sub(r'\b{0}\b'.format(k), '('+v+')', s)


def is_solved(v):
    return re.search(r'[0-9]', v) is None


def parse(lines):
    return parse_rules(lines), parse_values(lines)


def parse_rules(lines):
    strings = filter(lambda l: ':' in l, lines)
    lists = [s.replace('"', '').split(': ') for s in strings]
    return {a[0]: a[1] for a in lists}


def parse_values(lines):
    return list(filter(lambda l: (':' not in l) and '' != l, lines))


if __name__ == '__main__' and not sys.flags.interactive:
    lines = [l.strip() for l in fileinput.input()]
    rules, values = parse(lines)
    print(part_one(rules, values))
