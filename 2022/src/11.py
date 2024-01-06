import fileinput
from collections import deque
from copy import deepcopy
from functools import reduce


def solve_1(monkeys):
    for _ in range(20):
        for monkey in monkeys:
            step_1(monkeys, monkey)
    inspections = [m['inspections'] for m in monkeys]
    inspections.sort()
    inspections.reverse()
    return inspections[0]*inspections[1]


def solve_2(monkeys):
    print(bigval)
    for _ in range(10000):
        for monkey in monkeys:
            step_2(monkeys, monkey)
    inspections = [m['inspections'] for m in monkeys]
    inspections.sort()
    inspections.reverse()
    return inspections[0]*inspections[1]


def step_1(monkeys, monkey):
    items = monkey['items']
    while items:
        monkey['inspections'] += 1
        item = items.popleft()
        item = monkey['operation'](item)//3
        if item % monkey['test'] == 0:
            dst = monkey['next_t']
        else:
            dst = monkey['next_f']
        monkeys[dst]['items'].append(item)


def step_2(monkeys, monkey):
    items = monkey['items']
    while items:
        monkey['inspections'] += 1
        item = items.popleft()
        key = (monkey['n'], item)
        test = monkey['test']
        item = monkey['operation'](item)
        if item % test == 0:
            dst = monkey['next_t']
        else:
            dst = monkey['next_f']

        next_monkey = monkeys[dst]
        next_monkey['items'].append(item % bigval)


lines = [line.strip() for line in fileinput.input()]
monkeys = []
while True:
    n = len(monkeys)
    start = n*7
    if start > len(lines):
        break
    items = deque([int(s) for s in lines[start + 1].split(': ')[1].split(', ')])
    expr = lines[start+2].split('= ')[1]
    operation = lambda old, expr=expr: eval(expr.replace('old', str(old)))
    test = int(lines[start+3][19:])
    next_t = int(lines[start+4][25:])
    next_f = int(lines[start+5][26:])
    monkey = {
            'n': n,
            'items': items,
            'operation': operation,
            'test': test,
            'next_t': next_t,
            'next_f': next_f,
            'inspections': 0,
            }
    monkeys.append(monkey)
bigval = reduce(lambda x, y: x * y, [monkey['test'] for monkey in monkeys])
print(solve_1(deepcopy(monkeys)))
print(solve_2(monkeys))
