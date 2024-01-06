import fileinput
import re
import sys
from itertools import permutations


def parse(lines):
    return [parseLine(line) for line in lines]


def parseLine(line):
    m = re.match(r'(?P<name>\w+) would (?P<op>\w+) (?P<amount>\w+) happiness units by sitting next to (?P<next_to>\w+)', line)
    d = m.groupdict()
    if d.get('op') == 'lose':
        d['amount'] = -int(d['amount'])
    else:
        d['amount'] = int(d['amount'])
    return d


def transform(raw_data):
    result = dict()
    for r in raw_data:
        n = r.get('name')
        if n not in result:
            result[n] = dict()
        d = result.get(n)
        d[r.get('next_to')] = r.get('amount')
    return result


def add_me(data):
    names = list(data)
    data['me'] = dict()
    for n in names:
        data.get(n)['me'] = 0
        data.get('me')[n] = 0


def find_max(data):
    known_max = -2**63
    names = list(data)
    for p in permutations(names):
        sits = [t for t in zip(p, p[1:]+p[:1])]
        h = happiness(data, sits)
        if h > known_max:
            known_max = h
    return known_max


def happiness(data, sits):
    result = 0
    for pair in sits:
        result += data.get(pair[0]).get(pair[1])
        result += data.get(pair[1]).get(pair[0])
    return result


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    raw_data = parse(lines)
    data = transform(raw_data)
    print(find_max(data))
    add_me(data)
    print(find_max(data))
