from itertools import groupby


def solve_1(game):
    with_strength = [((kind(hand[0]), values(hand[0])), hand[0], hand[1])
            for hand in game]
    return solve(with_strength)


def solve_2(game):
    with_strength = [((highest_kind(hand[0]), values(hand[0], True)), hand[0], hand[1])
            for hand in game]
    return solve(with_strength)


def solve(with_strength):
    result = 0
    previous_s = None
    for i, v in enumerate(sorted(with_strength)):
        rank = i+1
        result += rank * v[2]
        print(rank, v, v[0] == previous_s)
        assert(v[0] != previous_s)
        previous_s = v[0]
    return result


def kind(cards):
    sorted_cards = sorted(cards)
    ns = []
    previous = sorted_cards[0]
    n = 0
    for c in sorted_cards:
        if c == previous:
            n += 1
        else:
            ns.append(n)
            n = 1
        previous = c
    ns.append(n)
    ns.sort(reverse=True)
    if ns == [5]:
        return 6
    if ns == [4, 1]:
        return 5
    if ns == [3, 2]:
        return 4
    if ns == [3, 1, 1]:
        return 3
    if ns == [2, 2, 1]:
        return 2
    if ns == [2, 1, 1, 1]:
        return 1
    if ns == [1, 1, 1, 1, 1]:
        return 0
    assert(False)


def highest_kind(cards):
    if cards == 'JJJJJ':
        return 6
    result = 0
    for r in ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2']:
        new = kind(cards.replace('J', r))
        result = max(result, new)
    return result


def values(cards, p2=False):
    conf = { 'T': 'a', 'J': 'b', 'Q': 'c', 'K': 'd', 'A': 'e' }
    if p2:
        conf = { 'T': 'a', 'J': '0', 'Q': 'c', 'K': 'd', 'A': 'e' }
    result = ''
    for c in cards:
        if c in conf:
            result += conf[c]
        else:
            result += c
    return result
    

ex = """32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""
txt = ex
# txt = open(0).read()
lines = txt[:-1].split('\n')
game = [(line.split()[0], int(line.split()[1])) for line in lines]
print(solve_1(game))
print(solve_2(game))
