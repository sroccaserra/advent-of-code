import fileinput
import sys
from collections import defaultdict


def solve_part_one(lines):
    scheduler = SchedulerPartOne(lines)
    while len(scheduler.options()) > 0:
        scheduler.step()
    return scheduler.path


IS_EXAMPLE = False
QUEUE_SIZE = 2 if IS_EXAMPLE else 5
TIME_BASE = 0 if IS_EXAMPLE else 60

def solve_part_two(lines):
    scheduler = SchedulerPartTwo(lines)
    while not scheduler.is_done():
        scheduler.step()
    return scheduler.time


class SchedulerPartOne:
    def __init__(self, lines):
        deps = [(line[5], line[36]) for line in lines]
        self.chars = set([d[0] for d in deps] + [d[1] for d in deps])
        self.m = defaultdict(set)
        for dep in deps:
            self.m[dep[1]].add(dep[0])
        self.path = ''

    def options(self):
        return [c for c in self.chars if len(self.m[c]) == 0]

    def choose(self):
        possible_values = self.options()
        if len(possible_values) == 0:
            return None
        return sorted(self.options())[0]

    def step(self):
        choice = self.choose()
        self.path += choice
        self.chars.remove(choice)
        for c in self.chars:
            for k, v in self.m.items():
                self.m[k].discard(choice)
        return self

    def __str__(self):
        return f'SchedulerPartOne(path: {repr(self.path)}, map: {self.m}, chars: {self.chars})'


class SchedulerPartTwo:
    def __init__(self, lines):
        deps = [(line[5], line[36]) for line in lines]

        self.chars = set([d[0] for d in deps] + [d[1] for d in deps])

        self.m = defaultdict(set)
        for dep in deps:
            self.m[dep[1]].add(dep[0])

        self.time = -1
        self.queue = []

    def options(self):
        return sorted([c for c in self.chars if len(self.m[c]) == 0])

    def has_room(self):
        return len(self.queue) < QUEUE_SIZE

    def is_done(self):
        return (0 == len(self.queue)) and (0 == len(self.chars))

    def is_in_queue(self, c):
        for queued in self.queue:
            if c == queued[0]:
                return True
        return False


    def step(self):
        if self.is_done():
            return self
        self.time += 1
        self.update_queue()
        choices = self.options()
        for choice in choices:
            if self.has_room():
                self.queue.append((choice, time(choice)))
                self.chars.remove(choice)

        return self

    def update_queue(self):
        for i, queued in enumerate(self.queue.copy()):
            t = queued[1]
            t -= 1
            updated = (queued[0], t)
            self.queue[i] = updated
        for i, queued in enumerate(self.queue.copy()):
            t = queued[1]
            if t <= 0:
                self.queue.remove(queued)
                for c in self.chars:
                    for k, v in self.m.items():
                        self.m[k].discard(queued[0])

    def __str__(self):
        return f'SchedulerPartTwo(time: {self.time}, has_room: {self.has_room()}, queue: {self.queue}, map: {self.m}, chars: {self.chars})'


def time(c):
    return TIME_BASE + 1 + ord(c)- ord('A')


if __name__ == '__main__' and not sys.flags.interactive:
    lines = [line.strip() for line in fileinput.input()]
    print(solve_part_one(lines))
    print(solve_part_two(lines))
