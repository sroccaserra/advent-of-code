def solve(expected_diff, patterns):
    result_h = 0
    result_v = 0
    for p in patterns:
        result_h += count_with_diff_horizontally(expected_diff, p)
        w = len(p[0])
        h = len(p)
        transposed = []
        for j in range(w):
            row = []
            transposed.append(row)
            for i in range(h):
                row.append(p[i][j])
        result_v += count_with_diff_horizontally(expected_diff, transposed)

    return result_h*100+result_v


def count_with_diff_horizontally(expected_diff, pattern):
    n = 0
    for n in range(len(pattern)-1):
        a = min(n+1, len(pattern)-n-1)
        start = n+1-a
        end = n+1+a
        sub = pattern[start:end]
        w = len(sub[0])
        i = 0
        diff = 0
        for line_r in reversed(sub):
            line = sub[i]
            for j in range(w):
                if line[j] != line_r[j]:
                    diff += 1
            i += 1
        if diff == 2*expected_diff:
            return n+1
    return 0


ex = """#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""
text = ex
text = open(0).read()
patterns = [lines.split('\n') for lines in text[:-1].split('\n\n')]
print(solve(0, patterns))
print(solve(1, patterns))
