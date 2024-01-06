import fileinput
import sys


def parse(lines):
    program = []
    for line in lines:
        program.append(parseLine(line))
    return program


def parseLine(line):
    words = line.split()
    op = words[0]
    if op == 'jio' or op == 'jie':
        words[2] = int(words[2])
        words[1] = words[1][:-1]
    if op == 'jmp':
        words[1] = int(words[1])
    return words


def solve_1(program):
    machine = {'pc': 0, 'a': 0, 'b': 0, 'halt': False}
    return run(machine, program)


def solve_2(program):
    machine = {'pc': 0, 'a': 1, 'b': 0, 'halt': False}
    return run(machine, program)


def run(machine, program):
    while not machine['halt'] and (machine['pc'] < len(program)):
        instruction = program[machine.get('pc')]
        # print('------------')
        # print('machine:', machine)
        # print('instruction:', instruction)
        execute_instruction(instruction, machine)
        # print('machine:', machine)
    return machine


def execute_instruction(instruction, machine):
    op = instruction[0]
    if op == 'jie':
        if 0 == (machine.get(instruction[1]) % 2):
            machine['pc'] += instruction[2]
        else:
            machine['pc'] += 1
    elif op == 'jio':
        if 1 == (machine.get(instruction[1])):
            machine['pc'] += instruction[2]
        else:
            machine['pc'] += 1
    elif op == 'inc':
        machine[instruction[1]] += 1
        machine['pc'] += 1
    elif op == 'tpl':
        machine[instruction[1]] *= 3
        machine['pc'] += 1
    elif op == 'jmp':
        machine['pc'] += instruction[1]
    elif op == 'hlf':
        machine[instruction[1]] /= 2
        machine['pc'] += 1
    else:
        machine['halt'] = True


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    program = parse(lines)
    print(solve_1(program))
    print(solve_2(program))
