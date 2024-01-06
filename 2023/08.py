def solve_1(instructions, graph):
    pos = 'AAA'
    pc = 0
    result = 0
    while pos != 'ZZZ':
        c = instructions[pc]
        if c == 'L':
            pos = graph[pos][0]
        else:
            pos = graph[pos][1]
        result += 1
        pc = (pc+1) % len(instructions)
    return result

UNKNOWN = -1

def solve_2(instructions, graph):
    positions = []
    for pos in graph.keys():
        if pos.endswith('A'):
            positions.append(pos)
    pc = 0
    counter = 0
    info = []
    for pos in positions:
        info.append((UNKNOWN, UNKNOWN))
    while not all([z1 != UNKNOWN and z2 != UNKNOWN for z1, z2 in info]):
        c = instructions[pc]
        if c == 'L':
            index = 0
        else:
            index = 1
        next_state = []
        for pos in positions:
            dest = graph[pos][index]
            next_state.append(dest)
        positions = next_state
        counter += 1
        pc = (pc+1) % len(instructions)
        for i in range(len(positions)):
            pos = positions[i]
            if pos.endswith('Z'):
                z1, z2 = info[i]
                if z1 == UNKNOWN:
                    z1 = counter
                    info[i] = (z1, z2)
                elif z2 == UNKNOWN:
                    assert z1 != UNKNOWN
                    z2 = counter-z1
                    assert z2 == z1
                    info[i] = (z1, z2)
    seen = set()
    result = 1
    for z1, _ in info:
        for fac in factors(z1):
            if fac not in seen:
                seen.add(fac)
                result *= fac
    return result


def factors(nr):
    i = 2
    result = []
    while i <= nr:
        if (nr % i) == 0:
            result.append(i)
            nr = nr / i
        else:
            i = i + 1
    return result


ex = """RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"""

ex = """LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"""

text = ex
text = open(0).read()

parts = text.split('\n\n')
instructions = parts[0]
node_lines = parts[1].split('\n')[:-1]
graph = {}
for line in node_lines:
    graph[line[0:3]] = (line[7:10], line[12:15])

print(solve_1(instructions, graph))
print(solve_2(instructions, graph))
