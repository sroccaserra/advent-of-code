import fileinput


def solve(rope, commands):
    visited = {tuple(rope[-1])}
    # print()
    # print_points(visited, rope)
    for command in commands:
        action = actions.get(command[0])
        for _ in range(command[1]):
            action(rope[0])
            for i in range(1, len(rope)):
                follow(rope[i-1], rope[i])
            visited.add(tuple(rope[-1]))
            # print(command)
            # print_points(visited, rope)
    return len(visited)


def print_points(visited, rope):
    xs = [p[0] for p in visited]
    ys = [p[1] for p in visited]
    for (x, y) in rope:
        xs.append(x)
        ys.append(y)
    for y in range(max(ys), min(ys)-1, -1):
        for x in range(min(xs), max(xs)+1):
            c = '.'
            if (x, y) in visited:
                c = '#'
            if [x, y] in rope:
                c = rope.index([x, y])
            print(c, end='')
        print()


def up(head):
    head[1] += 1


def down(head):
    head[1] -= 1


def left(head):
    head[0] -= 1


def right(head):
    head[0] += 1


def follow(h, t):
    xh, yh = h
    xt, yt = t
    if abs(xh - xt) > 1 and abs(yh - yt) > 1:
        t[0] += (xh - xt)//2
        t[1] += (yh - yt)//2
    elif abs(xh - xt) > 1:
        t[0] += (xh - xt)//2
        t[1] = yh
    elif abs(yh - yt) > 1:
        t[0] = xh
        t[1] += (yh - yt)//2


actions = { 'U': up, 'D': down, 'L': left, 'R': right}


commands = [(line[0], int(line.strip()[2:]))for line in fileinput.input()]
print(solve([[0, 0], [0, 0]],commands))
print(solve([[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]],commands))
