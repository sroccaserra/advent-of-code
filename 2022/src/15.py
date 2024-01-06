import fileinput
import re


# LINENO = 10
# RANGE = 20
LINENO = 2000000
RANGE = 4000000


def solve_1(readings):
    segments = []
    beacons = []
    min_x = 999999999999999999
    max_x = 0
    for (x1, y1, x2, y2) in readings:
        d = distance(x1, y1, x2, y2)
        if y2 == LINENO:
            beacons.append(x2)
        toline = abs(y1 - LINENO)
        if toline <= d:
            amplitude = d - toline
            segments.append((x1-amplitude, x1+amplitude))
            min_x = min(x1 - amplitude, min_x)
            max_x = max(x1 + amplitude, max_x)
    result = 0
    for x in range(min_x, max_x+1):
        for (x1, x2) in segments:
            if x1 <= x <= x2 and x not in beacons:
                # print(x1, x, x2)
                result +=1
                break
    return result


def solve_2(readings):
    candidates = []
    for lineno in range(RANGE+1):
        segments = []
        for (x1, y1, x2, y2) in readings:
            d = distance(x1, y1, x2, y2)
            toline = abs(y1 - lineno)
            if toline <= d:
                amplitude = d - toline
                segments.append((x1-amplitude, x1+amplitude))
        segments.sort()
        for i in range(len(segments) - 1):
            if segments[i][1] + 2 == segments[i+1][0]:
                x = segments[i][1]+1
                out = True
                for x1, x2 in segments:
                    if x1 <= x <= x2:
                        out = False
                        break
                if out:
                    candidates.append((x, lineno))
        # if lineno % 100000 == 0:
        #     print(lineno)
    assert len(candidates) == 1
    p = candidates[0]
    return p[0]*4000000+p[1]


def distance(x1, y1, x2, y2):
    return abs(x2-x1) + abs(y2-y1)


readings = [[int(s) for s in re.findall(r'=([-0-9]+)', line.strip())] for line in fileinput.input()]
print(solve_1(readings))
print(solve_2(readings))
