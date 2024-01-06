def solve(numbers):
    next_ns = [compute_next(ns) for ns in numbers]
    left_ns = [ns[0] for ns in next_ns]
    right_ns = [ns[1] for ns in next_ns]
    return sum(left_ns), sum(right_ns)


def compute_next(ns):
    result_right = 0
    first_ns = []
    while True:
        result_right += ns[-1]
        first_ns.append(ns[0])
        are_all_zeroes = all(n == 0 for n in ns)
        if are_all_zeroes:
            break
        next_ns = []
        for i in range(len(ns)-1):
            next_ns.append(ns[i+1] - ns[i])
        ns = next_ns
    result_left = 0
    for i in range(len(first_ns)-1, -1, -1):
        result_left = first_ns[i] - result_left
    return result_left, result_right


ex = """0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""
text = ex
# text = open(0).read()
numbers = [[int(w) for w in line.split()] for line in text.split('\n')[:-1]]
print(solve(numbers))
