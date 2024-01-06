import fileinput
import re
import sys


def part_one(lines):
    grid = [0] * 1000000
    commands = [parse_line(line) for line in lines]
    for command in commands:
        execute_command_part_one(grid, command)
    return len(list(filter(lambda x: x == 1, grid)))


def part_two(lines):
    grid = [0] * 1000000
    commands = [parse_line(line) for line in lines]
    for command in commands:
        execute_command_part_two(grid, command)
    return sum(grid)


def parse_line(line):
    r = r"([a-z ]+) ([0-9]+)\,([0-9]+) through ([0-9]+),([0-9]+)"
    result = re.match(r, line)
    return (
        result.group(1),
        (int(result[2]), int(result[3])),
        (int(result[4]), int(result[5])),
    )


def execute_command_part_one(grid, command):
    c, (x1, y1), (x2, y2) = command
    for y in range(y1, y2 + 1):
        for x in range(x1, x2 + 1):
            offset = y * 1000 + x
            if c == "turn off":
                grid[offset] = 0
            elif c == "turn on":
                grid[offset] = 1
            else:
                grid[offset] = 1 - grid[offset]
    return grid


def execute_command_part_two(grid, command):
    c, (x1, y1), (x2, y2) = command
    for y in range(y1, y2 + 1):
        for x in range(x1, x2 + 1):
            offset = y * 1000 + x
            if c == "turn off":
                grid[offset] = max(0, grid[offset] - 1)
            elif c == "turn on":
                grid[offset] = grid[offset] + 1
            else:
                grid[offset] = grid[offset] + 2
    return grid


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    print(part_two(lines))
