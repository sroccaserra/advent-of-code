def solve_1(n):
    recipies = [3,7]
    pos_1 = 0
    pos_2 = 1
    while len(recipies) < n+10:
        (pos_1, pos_2) = step(recipies, pos_1, pos_2)

    numbers = recipies[n:n+10]
    result = ""
    for n in numbers:
        result += str(n)
    return result


def solve_2(target):
    recipies = [3,7]
    pos_1 = 0
    pos_2 = 1
    n = len(target)

    while recipies[-n:] != target and recipies[-n-1:-1] != target :
        (pos_1, pos_2) = step(recipies, pos_1, pos_2)

    if recipies[-n:] == target:
        return len(recipies) - n
    else:
        return len(recipies)- n - 1


def step(recipies, pos_1, pos_2):
    n_1 = recipies[pos_1]
    n_2 = recipies[pos_2]
    s = n_1 + n_2

    if s >= 10:
        recipies.append(1)
        recipies.append(s - 10)
    else:
        recipies.append(s)

    return (pos_1+n_1+1) % len(recipies), (pos_2+n_2+1) % len(recipies)


print(solve_1(47801))
print(solve_2([0, 4, 7, 8, 0, 1]))
