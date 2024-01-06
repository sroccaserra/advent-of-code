import fileinput


def solve_1(trees):
    w = len(trees[0])
    h = len(trees)
    result = 0
    for y in range(h):
        for x in range(w):
            tree = trees[y][x]
            trees_in_sight = lines_of_sight(trees, x, y)
            is_visible = False
            for line in trees_in_sight:
                if len(line) == 0 or (max(line) < tree):
                    is_visible = True
            if is_visible:
                result += 1
    return result


def solve_2(trees):
    w = len(trees[0])
    h = len(trees)
    result = 0
    for y in range(h):
        for x in range(w):
            tree = trees[y][x]
            trees_in_sight = lines_of_sight(trees, x, y)
            score = 1
            for line in trees_in_sight:
                score *= distance_in_line(line, tree)
            if score > result:
                result = score
    return result


def lines_of_sight(trees, x, y):
    w = len(trees[0])
    h = len(trees)
    result = []
    ray = []
    for i in range(x+1,w):
        ray.append(trees[y][i])
    result.append(ray)
    ray = []
    for i in range(x-1, -1, -1):
        ray.append(trees[y][i])
    result.append(ray)
    ray = []
    for i in range(y+1, h):
        ray.append(trees[i][x])
    result.append(ray)
    ray = []
    for i in range(y-1, -1, -1):
        ray.append(trees[i][x])
    result.append(ray)
    return result


def distance_in_line(line, tree):
    result = 0
    for other_tree in line:
        if tree <= other_tree:
            result +=1
            return result
        result += 1
    return result


trees = [[int(c) for c in line.rstrip()] for line in fileinput.input()]
print(solve_1(trees))
print(solve_2(trees))
