import fileinput


def solve(numbers, nb_mixes, key):
    size = len(numbers)
    moved = [(i, n*key) for i, n in enumerate(numbers)]
    p = 0
    for n_mix in range(nb_mixes):
        for i in range(size):
            while True:
                (nb_mixed, n) = moved[p]
                if nb_mixed == i:
                    break
                p = (p + 1)%size
            src = p
            nb_moves = n%(size-1)
            if nb_moves == 0:
                moved[src] = (nb_mixed, n)
            for _ in range(nb_moves):
                dst = (src+1)%size
                tmp = moved[dst]
                moved[dst] = (nb_mixed, n)
                moved[src] = tmp
                src = dst

    offset = 0
    for (_, n) in moved:
        if n == 0:
            break
        offset += 1
    (_, a) = moved[(1000+offset)%size]
    (_, b) = moved[(2000+offset)%size]
    (_, c) = moved[(3000+offset)%size]
    return a + b + c


numbers = [int(line.strip()) for line in fileinput.input()]
print(solve(numbers, 1, 1))
print(solve(numbers, 10, 811589153))
