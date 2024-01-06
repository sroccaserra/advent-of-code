from re import split
from collections import deque


def solve_1(cards):
    result = 0
    for card in cards:
        prize = -1
        for have in card[1]:
            if have in card[0]:
                prize += 1
        if prize >= 0:
            result += pow(2, prize)
    return result


def solve_2(cards):
    result = len(cards)
    indexed = [(i, v) for i,v in enumerate(cards)]
    q = deque(indexed)
    while q:
        index, card = q.popleft()
        k = index
        for have in card[1]:
            if have in card[0]:
                k = k+1
                q.append(indexed[k])
                result += 1
    return result


ex = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""


file = ex
# file = open(0).read()
lines = file[:-1].split('\n')
cards = [[part.split() for part in split(r': | \| ', line)[1:]] for line in lines]
print(solve_1(cards))
print(solve_2(cards))
