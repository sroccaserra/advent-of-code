import fileinput
import sys
from re import finditer


def parse(lines):
    replacements = dict()
    for line in lines:
        if '=>' in line:
            xs = line.split(' => ')
            if xs[0] not in replacements:
                replacements[xs[0]] = []
            replacements[xs[0]].append(xs[1])
    return (replacements, lines[-1])


def solve_1(data):
    replacements = data[0]
    molecule = data[1]
    results = []
    for pattern in replacements.keys():
        matches = finditer(pattern, molecule)
        for m in matches:
            s = m.span()
            start = molecule[:s[0]]
            end = molecule[s[1]:]
            for rep in replacements[pattern]:
                results.append(start+rep+end)

    return len(set(results))


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    data = parse(lines)
    print(solve_1(data))
