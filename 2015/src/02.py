import fileinput


def area(xs):
    l, w, h = xs
    return min(l * w, w * h, h * l) + 2 * (l * w + w * h + h * l)


def ribbon(xs):
    l, w, h = xs
    m = max(l, w, h)
    return 2 * (l + w + h - m) + l * w * h


lines = [line.strip().split("x") for line in fileinput.input()]
ns = [[int(x) for x in line] for line in lines]

print(sum([area(x) for x in ns]))
print(sum([ribbon(x) for x in ns]))
