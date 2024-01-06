import re


def solve_1(lines):
    result = 0
    h = {}
    for line in lines:
        parts = line.split()
        ns = tuple([int(s) for s in parts[1].split(',')])
        result += count(h, parts[0], ns)
    return result


def solve_2(lines):
    result = 0
    h = {}
    for line in lines:
        parts = line.split()
        s =  '?'.join([parts[0]]*5)
        ns = tuple([int(s) for s in parts[1].split(',')]*5)
        result += count(h, s, ns)
    return result


# Un genre de Fibonacci, mais récursion sur deux listes (s et ns)
# => deux conditions d'arrêt
# => deux conditions de récursion
def count(h, s, ns):
    # Deux conditions d'arrêt
    if s == '':
        return 1 if ns == () else 0
    if ns == ():
        return 0 if '#' in s else 1

    if (s, ns) in h:
        return h[(s, ns)]
    result = 0  # On va passer dans deux conditions de récursion => il faudra faire la somme
    c = s[0]
    # On note que le '?' rentre dans les deux branches ci-dessous
    if c in '.?':  # Première condition de récursion
        result += count(h, s[1:], ns)
    if c in '#?':  # Deuxième condition de récursion
        n = ns[0]
        if n <= len(s) and '.' not in s[:n] and (n == len(s) or s[n] != '#'):
            result += count(h, s[n+1:], ns[1:])
    h[(s, ns)] = result
    return result


ex = """???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""
text = ex
# text = open(0).read()
lines = text.split('\n')[:-1]
print(solve_1(lines))
print(solve_2(lines))
