from collections import defaultdict, deque


Pos = tuple[int, int]
Dist = int


def solve_1(lines, max_steps=6):
    w = len(lines[0])
    h = len(lines)
    start_pos = (-1, -1)
    grid = defaultdict(lambda: '#')
    for i in range(h):
        line = lines[i]
        for j in range(w):
            c = line[j]
            if c == 'S':
                start_pos = (i, j)
            grid[i, j] = line[j]
    q:deque[tuple[Pos, Dist]] = deque([(start_pos, 0)])
    seen:set[tuple[Pos, Dist]] = set([(start_pos, 0)])
    dests:set[Pos] = set()
    while q:
        pos, dist = q.popleft()
        for next_pos in neighbors_1(grid, pos):
            next_dist = dist + 1
            next_node = (next_pos, next_dist)
            if next_node in seen:
                continue
            if next_dist < max_steps:
                q.append(next_node)
                seen.add(next_node)
            elif next_dist == max_steps:
                dests.add(next_pos)
            else: assert False
    return len(dests)


def solve_2(lines, max_steps=6):
    w = len(lines[0])
    h = len(lines)
    start_pos = (-1, -1)
    for i in range(h):
        line = lines[i]
        for j in range(w):
            c = line[j]
            if c == 'S':
                start_pos = (i, j)
    q:deque[tuple[Pos, Dist]] = deque([(start_pos, 0)])
    seen:set[tuple[Pos, Dist]] = set([(start_pos, 0)])
    dests:set[Pos] = set()
    first_reached = {start_pos: 0}
    while q:
        pos, dist = q.popleft()
        for next_pos in neighbors_2(lines, w, h, pos):
            next_dist = dist + 1
            next_node = (next_pos, next_dist)
            if next_node in seen:
                continue
            if next_dist < max_steps:
                q.append(next_node)
                seen.add(next_node)
                i, j = next_pos
                i_m = i%h
                j_m = j%w
                if (i_m, j_m) not in first_reached:
                    first_reached[i_m, j_m] = next_dist
                else:
                    assert next_dist >= first_reached[i_m, j_m]
            elif next_dist == max_steps:
                dests.add(next_pos)
            else: assert False
    return len(dests), (max_steps)*(max_steps)


def neighbors_1(grid, pos):
    i, j = pos
    result = []
    for n in [(i+1, j), (i-1, j), (i, j+1), (i, j-1)]:
        if grid[n] != '#':
            result.append(n)
    return result


def neighbors_2(lines, w, h, pos):
    i, j = pos
    result = []
    for n_i, n_j in [(i+1, j), (i-1, j), (i, j+1), (i, j-1)]:
        if lines[n_i%h][n_j%w] != '#':
            result.append((n_i, n_j))
    return result


ex = '''...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
'''
text = ex
text = open(0).read()
lines = text.splitlines()
print(solve_1(lines, 6))
# print(solve_1(lines, 64))
print(solve_2(lines, 100))

'''

Notes

À chaque fois qu'on arrive en un point (i, j), on va toujours
générer la même suite de descendants.

Certaines zones de l'input semblent inaccessibles en modulo (les
zones non atteintes sont les mêmes pour n = 200 et n = 250) =>
peut-être qu'on peut s'arrêter quand ça se stabilise (?)

À chaque fois qu'on arrive quelque-part en n, on y revient en
n+2. Il y a un genre de clignottement qui s'établit
progressivement, ça établit une sorte de relation de parité.
C'est uniquement la frontière qui est variable.

La frontière s'étend en permanence, peut-on réellement s'arrêter
quand tous les modulos ont été atteints ?

On n'a besoin de conserver que le max (? pour chaque parité ?) en
chaque point, c'est qu'on peut y arriver en n

? Faire un parcours pour les paires et pour les impaires ? Sans doute pas besoin.

Est-ce que chaque case n'est accessible que pair ou impair ? Je pense ?

   0

   1
  1S1
   1

   2
  2.2
 2.2.2
  2.2
   2

   3
  3.3
 3.3.3
3.3S3.3
 3.3.3
  3.3
   3

Récursion paire : 2n -> 2(n+1) : 1 -> 1 + 8n

0: 1
2: 1+8


Récursion impaire : 2n+1 -> 2(n+1)+1
1: 4
3: 4+12

Récursion générale :

n = 0: s = 1,       2s = 2*1, s = 1*1
n = 1: s = 1+3,     2s = 4*2, s = 2*2
n = 2: s = 1+3+5,   2s = 6*3, s = 3*3
n = 3: s = 1+3+5+7, 2s = 8*4, s = 4*4

C'est borné par (n+1)^2, ça n'avance pas beaucoup car :
26501366**2 = 702322399865956

Je note que l'exemple et l'input est bordé de rangées vides.
Peut-être qu'on peut faire des coutures.

Je note que dans l'input il y a un diamant vide bien visible.

'''
