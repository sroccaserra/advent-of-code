import fileinput
import re


OPS = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y,
        '*': lambda x, y: x * y,
        '/': lambda x, y: x // y,
        }


def solve_1(monkeys):
    return shout(monkeys, 'root')


def solve_2(monkeys):
    m1, _, m2 = monkeys['root']
    target = shout(monkeys, m2)

    i = 0
    monkeys['humn'] = 0
    val_1 = shout(monkeys, m1)
    while True:
        i = i+1
        monkeys['humn'] = i
        val2 = shout(monkeys, m1)
        if val2 != val_1:
            break

    if val_1 < val2:
        i_lo = 0
        i_hi = 10000000000000
        assert target > val2
    elif val2 < val_1:
        i_lo = 10000000000000
        i_hi = 0
        assert target < val2
    else:
        raise Exception()

    while True:
        i = (i_hi+i_lo)//2
        monkeys['humn'] = i
        val_i = shout(monkeys, m1)
        if val_i == target:
            break
        if val_i > target:
            i_hi = i
        else:
            i_lo = i

    monkeys['humn'] = i-1
    if shout(monkeys, m1) == target:
        i = i-1
    return i


def shout(monkeys, name):
    value = monkeys[name]
    if type(value) == int:
        return value
    op = OPS[value[1]]
    return op(shout(monkeys, value[0]), shout(monkeys, value[2]))


monkey_info = [line.strip().split(': ') for line in fileinput.input()]
monkeys = {mi[0]: mi[1].split() for mi in monkey_info}
for name, parts in monkeys.items():
    if len(parts) == 1:
        monkeys[name] = int(parts[0])
print(solve_1(monkeys))
print(solve_2(monkeys))
