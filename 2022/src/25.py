from fileinput import input

def solve(lines):
    s = 0
    nss = [[CONV[c] for c in line] for line in lines]
    for ns in nss:
        temp = 0
        for n in ns:
            temp = temp * 5 + n
        s += temp
    return snafu(s)


def snafu(n):
    result = ''
    while n > 0:
        digit = (n-3)%5-2
        result = ICONV[digit] + result
        n = (n+2)//5
    return result


CONV = {'2': 2, '1': 1, '0': 0, '-': -1, '=': -2}
ICONV = {v: k for k, v in CONV.items()}
lines = [line.strip() for line in input()]
print(solve(lines))
