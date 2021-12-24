import sys
import fileinput
from types import SimpleNamespace
from collections import namedtuple, deque

State = namedtuple('State', ['w', 'x', 'y', 'z'])

REG_INDEX_FOR = {'w': 0, 'x': 1, 'y': 2, 'z': 3}


def solve_1(program):
    inps = deque([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    return apply_reved_program(inps)

def apply_program(program, inps):
    state = [0, 0, 0, 0]
    pc = 0
    n = 0
    for pc in range(len(program)):
        instruction = program[pc]
        if instruction[0] == 'inp':
            n = 0
        print(n, pc, instruction, state)
        n = n + 1
        apply_instruction(state, inps, instruction)
    return state

def apply_instruction(state, inps, instruction):
    op = instruction[0]
    a_index = REG_INDEX_FOR[instruction[1]]
    if op == 'inp':
        value = inps.popleft()
        state[a_index] = value
    elif op == 'add':
        add(state, a_index, instruction[2])
    elif op == 'mul':
        mul(state, a_index, instruction[2])
    elif op == 'div':
        div(state, a_index, instruction[2])
    elif op == 'mod':
        mod(state, a_index, instruction[2])
    elif op == 'eql':
        eql(state, a_index, instruction[2])
    else:
        assert False, instruction

def is_address(v):
    return v in ['w', 'x', 'y', 'z']


def add(state, a_index, b):
    if is_address(b):
        reg = REG_INDEX_FOR[b]
        rhs = state[reg]
    else:
        rhs = int(b)
    state[a_index] = state[a_index]+rhs

def mul(state, a_index, b):
    if is_address(b):
        reg = REG_INDEX_FOR[b]
        rhs = state[reg]
    else:
        rhs = int(b)
    state[a_index] = state[a_index]*rhs

def div(state, a_index, b):
    if is_address(b):
        reg = REG_INDEX_FOR[b]
        rhs = state[reg]
    else:
        rhs = int(b)
    state[a_index] = state[a_index]//rhs

def mod(state, a_index, b):
    if is_address(b):
        reg = REG_INDEX_FOR[b]
        rhs = state[reg]
    else:
        rhs = int(b)
    state[a_index] = state[a_index]%rhs

def eql(state, a_index, b):
    if is_address(b):
        reg = REG_INDEX_FOR[b]
        rhs = state[reg]
    else:
        rhs = int(b)
    lhs = state[a_index]
    if lhs == rhs:
        state[a_index] = 1
    else:
        state[a_index] = 0


def apply_reved_program(inps):
    result = 0
    for i in range(len(inps)):
        a, b, c = REVED_PROGRAM[i]
        result = reved(result, inps[i], a, b, c)
    return result

REVED_PROGRAM = [
        (1, 12, 7),
        (1, 12, 8),
        (1, 13, 2),
        (1, 12, 11),
        (26, -3, 6),
        (1, 10, 12),
        (1, 14, 14),
        (26, -16, 13),
        (1, 12, 15),
        (26, -8, 10),
        (26, -12, 6),
        (26, -7, 10),
        (26, -6, 8),
        (26, -11, 5)]

def reved(previous, inp, a, b, c):
    z0 = previous
    if (z0%26+b) == inp:
        result = z0 // a
    else:
        result = (z0//a) * 26 + inp + c
    return result


if __name__ == '__main__' and not sys.flags.interactive:
    program = [[w for w in line.strip().split()] for line in fileinput.input()]
    print(solve_1(program))
