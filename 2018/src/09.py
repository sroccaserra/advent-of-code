import sys
import fileinput

from collections import defaultdict

words = next(fileinput.input()).split()

nb_players = int(words[0])
last_marble = int(words[6])*100

class DLList:
    def __init__(self, value):
        self.prev = None
        self.next = None
        self.value = value

    def __str__(self):
        return f'{self.value}'


def print_dl(node):
    done = set()
    while node not in done:
        print(node, node.prev, node.next)
        done.add(node)
        node = node.next

current = DLList(0)
current.next = current
current.prev = current

players = defaultdict(int)
p = 0

def step(value, dl):
    global p
    p = 1 + (p % nb_players)
    if 0 == value % 23:
        target = dl.prev.prev.prev.prev.prev.prev
        global players
        players[p] += value + target.prev.value
        drop(target.prev)
        return target
    target = dl.next
    node = DLList(value)

    node.next = target.next
    node.prev = target

    target.next.prev = node
    target.next = node

    return node

def drop(dl):
    n = dl.next
    p = dl.prev
    dl.next.prev = p
    dl.prev.next = n
    pass

print(nb_players, last_marble)

for marble in range(1, last_marble+1):
    if 0 == marble % (last_marble / 100):
        print(marble)
    current = step(marble, current)

# print_dl(current)
print(players[max(players, key=players.get)])
