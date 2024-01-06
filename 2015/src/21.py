import sys
from types import SimpleNamespace
from itertools import combinations


def solve_1(boss_hp, boss_pw, boss_ac):
    shop = create_shop()

    min_gold = 1000
    for weapon in shop.weapons:
        for armor in shop.armor:
            for ring_1, ring_2 in combinations(shop.rings, 2):
                player = SimpleNamespace(hp=100, pw=0, ac=0)
                boss = SimpleNamespace(hp=boss_hp, pw=boss_pw, ac=boss_ac)
                player.pw += weapon.damage + ring_1.damage + ring_2.damage
                player.ac += armor.armor + ring_1.armor + ring_2.armor
                if player == fight(player, boss):
                    cost = weapon.cost + armor.cost + ring_1.cost + ring_2.cost
                    min_gold = min(cost, min_gold)
    return min_gold


def solve_2(boss_hp, boss_pw, boss_ac):
    shop = create_shop()

    max_gold = 0
    for weapon in shop.weapons:
        for armor in shop.armor:
            for ring_1, ring_2 in combinations(shop.rings, 2):
                player = SimpleNamespace(hp=100, pw=0, ac=0)
                boss = SimpleNamespace(hp=boss_hp, pw=boss_pw, ac=boss_ac)
                player.pw += weapon.damage + ring_1.damage + ring_2.damage
                player.ac += armor.armor + ring_1.armor + ring_2.armor
                if boss == fight(player, boss):
                    cost = weapon.cost + armor.cost + ring_1.cost + ring_2.cost
                    max_gold = max(cost, max_gold)
    return max_gold


def create_shop():
    weapons = [
            SimpleNamespace(name='Dagger', cost=8, damage=4, armor=0),
            SimpleNamespace(name='Shortsword', cost=10, damage=5, armor=0),
            SimpleNamespace(name='Warhammer', cost=25, damage=6, armor=0),
            SimpleNamespace(name='Longsword', cost=40, damage=7, armor=0),
            SimpleNamespace(name='Greataxe', cost=74, damage=8, armor=0),
            ]
    armor = [
            SimpleNamespace(name='No armor', cost=0, damage=0, armor=0),
            SimpleNamespace(name='Leather', cost=13, damage=0, armor=1),
            SimpleNamespace(name='Chainmail', cost=31, damage=0, armor=2),
            SimpleNamespace(name='Splintmail', cost=53, damage=0, armor=3),
            SimpleNamespace(name='Bandedmail', cost=75, damage=0, armor=4),
            SimpleNamespace(name='Platemail', cost=102, damage=0, armor=5),
    ]
    rings = [
            SimpleNamespace(name='No ring', cost=0, damage=0, armor=0),
            SimpleNamespace(name='No ring', cost=0, damage=0, armor=0),
            SimpleNamespace(name='Damage +1', cost=25, damage=1, armor=0),
            SimpleNamespace(name='Damage +2', cost=50, damage=2, armor=0),
            SimpleNamespace(name='Damage +3', cost=100, damage=3, armor=0),
            SimpleNamespace(name='Defense +1', cost=20, damage=0, armor=1),
            SimpleNamespace(name='Defense +2', cost=40, damage=0, armor=2),
            SimpleNamespace(name='Defense +3', cost=80, damage=0, armor=3),
            ]
    return SimpleNamespace(weapons=weapons, armor=armor, rings=rings)


def fight(player, boss):
    winner = None
    while winner is None:
        winner = turn(player, boss)
    return winner


def turn(player, boss):
    boss.hp -= max(1, player.pw - boss.ac)
    if boss.hp <= 0:
        return player
    player.hp -= max(1, boss.pw - player.ac)
    if player.hp <= 0:
        return boss


if __name__ == "__main__" and not sys.flags.interactive:
    print(solve_1(100, 8, 2))
    print(solve_2(100, 8, 2))
