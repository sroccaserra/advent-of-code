import fileinput
import sys
from types import SimpleNamespace


def parse(lines):
    return [parseLine(line) for line in lines]


def parseLine(line):
    words = line.split()
    result = SimpleNamespace(
            name=words[0][:-1],
            capacity=int(words[2][:-1]),
            durability=int(words[4][:-1]),
            flavor=int(words[6][:-1]),
            texture=int(words[8][:-1]),
            calories=int(words[10]),
            )
    return result


def solve(ingredients):
    result_1 = 0
    result_2 = 0
    for i in range(100):
        for j in range(0, 100-i):
            for k in range(0, 100-i-j):
                h = 100 - i - j - k
                s = score(ingredients, h, i, j, k)
                result_1 = max(s, result_1)
                cal = max(0, ingredients[0].calories*h + ingredients[1].calories*i + ingredients[2].calories*j + ingredients[3].calories*k)
                if (cal == 500):
                    result_2 = max(s, result_2)
    return [result_1, result_2]


def score(ingredients, h, i, j, k):
    c = max(0, ingredients[0].capacity*h + ingredients[1].capacity*i + ingredients[2].capacity*j + ingredients[3].capacity*k)
    d = max(0, ingredients[0].durability*h + ingredients[1].durability*i + ingredients[2].durability*j + ingredients[3].durability*k)
    f = max(0, ingredients[0].flavor*h + ingredients[1].flavor*i + ingredients[2].flavor*j + ingredients[3].flavor*k)
    t = max(0, ingredients[0].texture*h + ingredients[1].texture*i + ingredients[2].texture*j + ingredients[3].texture*k)
    return c*d*f*t


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    ingredients = parse(lines)
    print(solve(ingredients))
