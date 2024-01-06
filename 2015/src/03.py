import fileinput


[commands] = [line.strip() for line in fileinput.input()]


D = {"^": (0, 1), ">": (1, 0), "v": (0, -1), "<": (-1, 0)}


def part_one(commands):
    return len(visits(commands))


def part_two(commands):
    santa = visits(commands[0::2])
    robo_santa = visits(commands[1::2])
    merged = dict()
    merged.update(santa)
    merged.update(robo_santa)
    return len(merged)


def visits(commands):
    (x, y) = (0, 0)
    visited = {(x, y): 1}
    for c in commands:
        (dx, dy) = D[c]
        (x, y) = (x + dx, y + dy)
        if (x, y) in visited:
            visited[(x, y)] += 1
        else:
            visited[(x, y)] = 1
    return visited


print(part_one(commands))
print(part_two(commands))
