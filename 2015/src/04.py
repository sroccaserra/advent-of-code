import fileinput
import hashlib


[code] = [line.strip() for line in fileinput.input()]


def part_one(code):
    n = 0
    while not md5(code + str(n)).startswith("00000"):
        n += 1
    return n


def part_two(code):
    n = 0
    while not md5(code + str(n)).startswith("000000"):
        n += 1
        if n % 1000000 == 0:
            print(n)
    return n


def md5(s):
    return hashlib.md5(s.encode("utf-8")).hexdigest()


print(part_one(code))
print(part_two(code))
