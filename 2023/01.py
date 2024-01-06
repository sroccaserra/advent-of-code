translations = {
        'zero': '0',
        'one': '1',
        'two': '2',
        'three': '3',
        'four': '4',
        'five': '5',
        'six': '6',
        'seven': '7',
        'eight': '8',
        'nine': '9',
        }


def solve_1(lines):
    result = 0
    for line in lines:
        cs = [c for c in line if c < 'a']
        if len(cs) == 0:
            continue
        n = int(cs[0] + cs[-1])
        result += n
    return result


def solve_2(lines):
    translated_lines = []
    for line in lines:
        translated_line = ''
        for fragment in [line[i:] for i in range(0, len(line))]:
            if fragment[0] < 'a':
                translated_line += fragment[0]
                continue
            for k,v in translations.items():
                if fragment.startswith(k):
                    translated_line += v
        translated_lines.append(translated_line)
    return solve_1(translated_lines)


lines = open(0).read()[:-1].split('\n')
print(solve_1(lines))
print(solve_2(lines))
