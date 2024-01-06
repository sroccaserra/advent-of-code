import fileinput
import re
import sys


def escape(s):
    a = re.sub(r'^"', "...", s)
    b = re.sub(r'"$', "...", a)
    c = re.sub(r'\\"', "....", b)
    d = re.sub(r"\\x", "...", c)
    e = re.sub(r"\\", "..", d)
    return e


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    unescaped = [eval(line) for line in lines]
    print(sum([len(x) for x in lines]) - sum([len(x) for x in unescaped]))
    escaped = [escape(line) for line in lines]
    print(sum([len(x) for x in escaped]) - sum([len(x) for x in lines]))
