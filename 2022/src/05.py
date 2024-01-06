import fileinput
from re import split
from copy import deepcopy


def solve_1(stacks, moves):
    for move in moves:
        src = stacks[move[1]-1]
        dst = stacks[move[2]-1]
        n = move[0]
        for _ in range(n):
            crate = src.pop()
            dst.append(crate)
    result = ''
    for stack in stacks:
        result += stack[-1]
    return result


def solve_2(stacks, moves):
    for move in moves:
        src = stacks[move[1]-1]
        dst = stacks[move[2]-1]
        n = move[0]
        tmp = []
        for _ in range(n):
            crate = src.pop()
            tmp.append(crate)
        for _ in range(n):
            crate = tmp.pop()
            dst.append(crate)
    result = ''
    for stack in stacks:
        result += stack[-1]
    return result


lines = [line.rstrip() for line in fileinput.input()]
sep = lines.index('')
header = lines[:sep-1]
moves = [[int(s) for s in split(r'\D+', line)[1:]] for line in lines[sep+1:]]
stacks = []
for n in reversed(range(len(header))):
    line = header[n]
    for i in range(1, len(line), 4):
        nstack = (i-1)//4
        if nstack >= len(stacks):
            stacks.append([])
        stack = stacks[nstack]
        c = line[i]
        if c != ' ':
            stack.append(line[i])
print(solve_1(deepcopy(stacks), moves))
print(solve_2(stacks, moves))
