def solve_1(vals):
    res = 1
    for t, d in vals:
        nb_wins = 0
        for ht in range(1, t):
            l = (t-ht)*ht
            if l > d:
                nb_wins += 1
        res *= nb_wins
    return res


def solve_2(vals):
    st, sd = "", ""
    for t, d in vals:
        st += str(t)
        sd += str(d)
    return solve_1([(int(st), int(sd))])


ex = [(7, 9), (15, 40), (30, 200)]
my = [(41 , 249), (77, 1362), (70 , 1127), (96, 1011)]

vals = ex
# vals = my

print(solve_1(vals))
print(solve_2(vals))
