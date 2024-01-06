from functools import reduce
import fileinput
import re
import sys


def parse_rules(lines):
    strings = filter(lambda l: ':' in l, lines)
    lists = [s.replace('"', '').split(': ') for s in strings]
    d = {a[0]: generate_alternatives(a[1]) for a in lists}
    rules = ['rule_{0} = {1}'.format(k, v) for k, v in d.items()]
    return [append_eof(r) for r in rules]


def generate_alternatives(s):
    if [] == re.findall('[0-9]', s):
        return 'string "{0}"'.format(s)
    return ' <|> '.join(generate_sequences(s.split(' | ')))


def generate_sequences(xs):
    return [generate_labels(s).replace(' ', ' *> ') for s in xs]


def generate_labels(s):
    return re.sub(r'([0-9]+)', r'rule_\1', s)


def append_eof(s):
    if s.startswith('rule_0 '):
        return s + ' *> eof'
    return s


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [l.strip() for l in fileinput.input()]
    rules = parse_rules(lines)
    for rule in rules:
        print(rule)
