from collections import deque


KIND = 0
DESTS=1


def solve_1(dictionary):
    # Setup
    state = {}
    convs = set()
    for name, (kind, dests) in dictionary.items():
        if kind == '&':
            convs.add(name)
            state[name] = {}
    missing = []
    for name, (kind, dests) in dictionary.items():
        if kind == '%':
            state[name] = 0
        for dest in dests:
            if dest in convs:
                state[dest][name] = 0
            if dest not in dictionary:
                missing.append(dest)
    for m in missing:
        dictionary[m] = ('?', [])
        state[m] = 0
    nb_low = 0
    nb_high = 0
    for _ in range(1000):
        press_result = press_button(dictionary, state)
        nb_low += press_result[0]
        nb_high += press_result[1]
    return nb_low * nb_high


def press_button(dictionary, state):
    # Button press
    nb_low = 1
    nb_high = 0
    src = 'broadcaster'
    _, dests = dictionary[src]
    q:deque[tuple[str, int, str]] = deque([(dest, 0, src) for dest in dests])
    while q:
        name, pulse, src = q.popleft()
        if pulse == 0:
            nb_low += 1
        elif pulse == 1:
            nb_high += 1
        kind, dests = dictionary[name]
        if kind == '%' and pulse == 0:
            new_state:int = 1 - state[name]
            state[name] = new_state
            for dest in dests:
                q.append((dest, new_state, name))
        elif kind == '&':
            conj_state = state[name]
            conj_state[src] = pulse
            new_pulse:int = 0 if all([inp == 1 for inp in conj_state.values()]) else 1
            for dest in dests:
                q.append((dest, new_pulse, name))
        elif kind == '?':
            state[name] = pulse
    return nb_low, nb_high


ex = """broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
"""
ex = '''broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
'''
text = ex
# text = open(0).read()
lines = text.splitlines()
dictionary = {}
for line in lines:
    if line.startswith('broadcaster'):
        broadcast_to = line.split(' -> ')[1].split(', ')
        dictionary['broadcaster'] = ('broadcaster', broadcast_to)
    else:
        chunks = line.split(' -> ')
        c = chunks[0][0] ; assert c in '%&'
        name = chunks[0][1:] ; assert name != ''
        dictionary[name] = (c, chunks[1].split(', '))
print(solve_1(dictionary))
