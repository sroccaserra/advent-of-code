import sys
from functools import cmp_to_key, reduce


NEXT = None


def solve_1(packet_pairs):
    result = 0
    for i in range(len(packet_pairs)):
        lhs, rhs = packet_pairs[i]
        if compare_packets(lhs, rhs) < 0:
           result += 1+i
    return result


def solve_2(packet_pairs):
    packets = list(reduce(lambda acc, x: acc + x, packet_pairs))
    packets.append([[2]])
    packets.append([[6]])
    sorted_packets = sorted(packets, key=cmp_to_key(compare_packets))
    return (sorted_packets.index([[2]])+1)*(sorted_packets.index([[6]])+1)


def compare_packets(lhs, rhs):
    if isinstance(lhs, int) and isinstance(rhs, int):
        if lhs == rhs:
            return NEXT
        return lhs - rhs
    lhs = coerce_list(lhs)
    rhs = coerce_list(rhs)
    common_len = min(len(lhs), len(rhs))
    for i in range(common_len):
        cmp = compare_packets(lhs[i], rhs[i])
        if cmp != NEXT:
            return cmp
    if len(lhs) == len(rhs):
        return NEXT
    return len(lhs) - len(rhs)


def coerce_list(x):
    if isinstance(x, list):
        return x
    return [x]


infile = sys.argv[1] if len(sys.argv)>1 else 'src/13.in'
line_pairs = open(infile).read().strip().split('\n\n')
packet_pairs = []
for s in line_pairs:
    ls, rs = s.split('\n')
    packet_pairs.append((eval(ls), eval(rs)))
print(solve_1(packet_pairs))
print(solve_2(packet_pairs))
