import fileinput
import sys

if __name__ == '__main__' and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    numbers = [int(l) for l in lines]
    print(sum(numbers))
