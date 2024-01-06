def solve_1(parts):
    return sum([h(s) for s in parts])


def solve_2(parts):
    ops = [parse(p) for p in parts]
    boxes = [[] for _ in range(256)]
    lenses = {}
    for op in ops:
        run(boxes, lenses, op)
    return focus(boxes, lenses)


def h(s):
    result = 0
    for c in s:
        result += ord(c)
        result *= 17
        result %= 256
    return result


def run(boxes, lenses, op):
    b = boxes[op[0]]
    label = op[1]
    if len(op) == 2:
        if label in b:
            b.remove(label)
    else:
        n = op[2]
        lenses[label] = n
        if label not in b:
            b.append(label)


def focus(boxes, lenses):
    result = 0
    for n, b in enumerate(boxes):
        for i, label in enumerate(b):
            result += (n+1)*(i+1)*lenses[label]
    return result


def parse(s):
    parts = s.split('=')
    if len(parts) == 2:
        label = parts[0]
        return (h(label), label, int(parts[1]))
    label = s[:-1]
    return (h(label), label)


ex = 'rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7'
text = ex
# text = open(0).read()[:-1]
parts = text.split(',')
print(solve_1(parts))
print(solve_2(parts))
