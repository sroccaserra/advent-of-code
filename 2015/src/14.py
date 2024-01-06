import fileinput
import sys
from types import SimpleNamespace


def parse(lines):
    return [parseLine(line) for line in lines]


def parseLine(line):
    words = line.split()
    result = SimpleNamespace(
            name=words[0],
            speed=int(words[3]),
            fly=int(words[6]),
            rest=int(words[13]),
            points=0)
    return result


def distance(reindeer, time):
    period = reindeer.fly + reindeer.rest
    remaining = min(time % period, reindeer.fly)
    return (time // period)*(reindeer.speed*reindeer.fly) + \
        remaining*reindeer.speed


def race_1(reindeers, time):
    return max([distance(r, time) for r in reindeers])


def race_2(reindeers, time):
    for i in range(1, time+1):
        race_status = [(distance(r, i), r.name) for r in reindeers]
        winners = find_leaders(race_status)
        for r in find_reindeers(reindeers, winners):
            r.points = r.points + 1
    return max([r.points for r in reindeers])


def find_leaders(race_status):
    sorted_result = sorted(race_status, reverse=True)
    winning_distance = sorted_result[0][0]
    result = []
    index = 0
    while index < len(sorted_result) and \
            sorted_result[index][0] == winning_distance:
        result.append(sorted_result[index][1])
        index += 1

    return result


def find_reindeers(reindeers, winners):
    result = []
    for name in winners:
        for r in reindeers:
            if r.name == name:
                result.append(r)
    return result


if __name__ == "__main__" and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    reindeers = parse(lines)
    print(race_1(reindeers, 2503))
    print(race_2(reindeers, 2503))
