import fileinput


def solve(commands):
    vm = { 'X': 1, 'ticks': 0 }
    probe = []
    for command in commands:
        wip = 0
        if command[0] == 'noop':
            wip = 1
        if command[0] == 'addx':
            wip = 2
        while wip:
            tick(vm, probe)
            put_pixel(vm)
            wip = wip -1
        if command[0] == 'addx':
            vm['X'] += command[1]
    return sum(probe)


def tick(vm, probe):
    vm['ticks'] += 1
    if (vm['ticks'] +20)% 40 == 0:
        probe.append(vm['ticks']*vm['X'])


def put_pixel(vm):
    beam_x = (vm['ticks'] - 1) % 40
    sx = vm['X']
    if sx - 1 <= beam_x <= sx + 1:
        print('#', end='')
    else:
        print('.', end='')
    if beam_x == 39:
        print()


lines = [line.strip() for line in fileinput.input()]
commands = []
for line in lines:
    parts = line.split()
    if len(parts) > 1:
        commands.append((parts[0], int(parts[1])))
    else:
        commands.append((line,))
print(solve(commands))
