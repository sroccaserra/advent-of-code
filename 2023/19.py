import re


MIN = 1
MAX = 4000
CATEGORIES = 'xmas'
NO_CATEGORY = 4


def solve_1(rules_dict, parts):
    result = 0
    for part in parts:
        dest = 'in'
        while dest in rules_dict:
            rules = rules_dict[dest]
            for category_index, value_min, value_max, rule_dest in rules[:-1]:
                if value_min <= part[category_index] <= value_max:
                    dest = rule_dest
                    break
            else:
                dest = get_dest(rules[-1])
        if dest == 'A':
            result += sum(part)
    return result


def check_hypothesis(rules_dict):
    for k, rules in rules_dict.items():
        # - There are always 2 or more rules
        assert len(rules) > 1
        # - The last rule is always the default dest
        for i in range(len(rules)-1):
            assert rules[i][0] != NO_CATEGORY
        assert rules[-1][0] == NO_CATEGORY


def parse_rules(lines):
    result = {}
    for line in lines:
        name = re.sub('{.*', '', line)
        branches = tuple([tuple(chunk.split(':')) for chunk in re.sub('.*{', '', line[:-1]).split(',')])
        split_confs = []
        result[name] = split_confs
        for rule in branches:
            if len(rule) == 1:
                split_confs.append((NO_CATEGORY, MIN, MAX, rule[0]))
            else:
                dest = rule[1]
                cond_str = rule[0]
                index = CATEGORIES.find(cond_str[0])
                n = int(cond_str[2:])
                value_min, value_max = (MIN, n-1) if cond_str[1] == '<' else (n+1, MAX)
                assert value_min < value_max
                split_confs.append((index, value_min, value_max, dest))
    return result


def get_dest(rule):
    return rule[3]


def parse_parts(lines):
    result = []
    for line in lines:
        ns = [int(s) for s in re.sub('[{}xmas=]', '', line).split(',')]
        result.append(tuple(ns))
    return result


ex = '''px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
'''
text = ex
# text = open(0).read()
chunks = text.split('\n\n')
rules_dict = parse_rules(chunks[0].splitlines())
parts = parse_parts(chunks[1].splitlines())
check_hypothesis(rules_dict)
print(solve_1(rules_dict, parts))
