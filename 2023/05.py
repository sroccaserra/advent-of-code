from math import inf


def solve_1(parts):
    ns = [int(s) for s in parts[0][0][7:].split()]
    rest = parts[1:]
    maps = [parse_maps(inst) for inst in rest]
    return min([convert(maps, n) for n in ns])


def solve_2(parts):
    ns = [int(s) for s in parts[0][0][7:].split()]
    ins = []
    for i in range(len(ns)//2):
        n0 = ns[2*i]
        n1 = n0 + ns[2*i+1] - 1
        assert n0 != n1
        ins.append((n0, n1))
    rest = parts[1:]
    maps = [parse_maps(inst) for inst in rest]
    result = inf
    for i in ins:
        n = min(min(convert_interval(maps, i)))
        if n < result:
            result = n
    return result


def parse_maps(map_struct):
    header_line = map_struct[0]
    header_parts = header_line.split('-to-')
    header = (header_parts[0][:2], header_parts[1][:2])

    map_lines = map_struct[1:]
    range_specs = [[int(s) for s in line.split()] for line in map_lines]
    return header, sorted([(spec[1], spec[1]+spec[2]-1, spec[0]-spec[1])
            for spec in range_specs])


def convert(maps, value):
    result = value
    for m in maps:
        buckets = m[1]
        for s, e, i in buckets:
            if s <= result <= e:
                result += i
                break
    return result


def convert_interval(maps, interval):
    intervals = [interval]
    for m in maps:
        converted = []
        for i in intervals:
            for c in convert_interval_for_map(m, i):
                converted.append(c)
        intervals = converted
    return sorted(intervals)


def convert_interval_for_map(m, interval):
    bs = m[1]
    result = []
    for b in bs:
        if overlaps(b, interval):
            inc = b[2]
            values_to_change = (max(interval[0], b[0]),
                    min(interval[1], b[1]))
            changed_values = (inc + values_to_change[0],
                    inc + values_to_change[1])
            result.append(changed_values)
            # i------i
            #   b--b
            if interval[0] < values_to_change[0] and values_to_change[1] < interval[1]:
                result.append((interval[0], values_to_change[0]-1))
                interval = (values_to_change[1]+1, interval[1])
            # i-----i
            #   b---b
            elif interval[0] < values_to_change[0]:
                interval = (interval[0], values_to_change[0]-1)
            # i-----i
            # b---b
            elif values_to_change[1] < interval[1]:
                interval = (values_to_change[1]+1, interval[1])
            else:
                assert interval[0] == values_to_change[0]
                assert interval[1] == values_to_change[1]
                return sorted(result)
        assert interval[0] != interval[1]
    result.append(interval)
    return sorted(result)


def overlaps(a, b):
    return a[0]<= b[1] and b[0] <= a[1]


ex = """seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""

text = ex[:-1]
# text = open(0).read()[:-1]
parts = [par.split('\n') for par in text.split('\n\n')]

print(solve_1(parts))
print(solve_2(parts))
