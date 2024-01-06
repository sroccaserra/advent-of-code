import re


def solve_1(dictionary, parts):
    result = 0
    for (x, m, a, s) in parts:
        dest = run_workflow(dictionary, x, m, a, s)
        if dest == 'A':
            result += x+m+a+s
    return result


def run_workflow(dictionary, x, m, a, s):
    dest = 'in'
    while dest in dictionary:
        rules = dictionary[dest]
        for rule in rules:
            if len(rule) == 1:
                dest = rule[0]
                break
            condition, rule_dest = rule
            if eval(condition):
                dest = rule_dest
                break
    return dest


def parse_rules(lines):
    dictionary = {}
    for line in lines:
        name = re.sub('{.*', '', line)
        branches = tuple([tuple(chunk.split(':')) for chunk in re.sub('.*{', '', line[:-1]).split(',')])
        dictionary[name] = branches
    return dictionary


def parse_parts(lines):
    result = []
    for line in lines:
        ns = [int(s) for s in re.sub('[{}xmas=]', '', line).split(',')]
        result.append(tuple(ns))
    return result


ex = """px{a<2006:qkq,m>2090:A,rfg}
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
"""
text = ex
# text = open(0).read()
chunks = text.split('\n\n')
dictionary = parse_rules(chunks[0].splitlines())
parts = parse_parts(chunks[1].splitlines())
print(solve_1(dictionary, parts))
