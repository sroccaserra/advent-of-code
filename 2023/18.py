def solve(read_polygon_fn, instructions):
    polygon = read_polygon_fn(instructions)
    return cube_meters(polygon)


def read_polygon_1(instructions):
    x, y = 0,0
    polygon = [(x, y)]
    for d, n, _ in instructions:
        if d == 'U':
            y -= n
        if d == 'D':
            y += n
        if d == 'L':
            x -= n
        if d == 'R':
            x += n
        polygon.append((x, y))
    return polygon


def read_polygon_2(isntructions):
    x, y = 0, 0
    polygon:list[tuple] = [(0, 0)]
    for _, _, h in instructions:
        d = ['R', 'D', 'L', 'U'][int(h[-1])]
        n = int(h[:-1], 16)
        if d == 'U':
            y -= n
        if d == 'D':
            y += n
        if d == 'L':
            x -= n
        if d == 'R':
            x += n
        polygon.append((x, y))
    return polygon


def cube_meters(polygon):
    length, area = 0, 0
    for i in range(len(polygon)-1):
        x1, y1 = polygon[i]
        x2, y2 = polygon[i+1]
        area += y1*(x1-x2)  # trapezoid formula: sum of ½(y1+y2)(x1-x2)
        length += abs(x2-x1) + abs(y2-y1)
    # `length//2 - 1` cube meters are already included in area =>
    # to count the full `length` cube metters, we add `length//2 + 1`
    return area + length//2 + 1


def parse(line):
    parts = line.split()
    return (parts[0], int(parts[1]), parts[2][2:-1])


ex = """R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
"""
text = ex
# text = open(0).read()
instructions = [parse(line) for line in text.splitlines()]
print(solve(read_polygon_1, instructions))
print(solve(read_polygon_2, instructions))
