import fileinput
import re


R = 0
D = 1
L = 2
U = 3
INCS = [(0, 1), (1, 0), (0, -1), (-1, 0)]
CHARS = ['>', 'v', '<', '^']
FACE_SIZE = 50
N_FACE_COLS = 3

flip_d = lambda d: (d+2)%4
incr_d = lambda d: (d+1)%4
decr_d = lambda d: (d-1)%4
flip_i_0 = lambda i, j: (FACE_SIZE-1-i, j)
flip_j_0 = lambda i, j: (i, FACE_SIZE-1-j)
flip_i_0_j_0 = lambda i, j: (FACE_SIZE-1-i, FACE_SIZE-1-j)
flip_j_0_i_0 = lambda i, j: (FACE_SIZE-1-j, FACE_SIZE-1-i)
swap_i_0_j_0 = lambda i, j: (j, i)
NO_DIR_CHANGE = lambda x: x
NO_TRANSFO = lambda i, j: (i, j)
TD_TRANSFO = lambda i, j: (i, j)
NO_CHANGE = ((0, 0), NO_TRANSFO, NO_DIR_CHANGE)
TD_CHANGE = ((0, 0), NO_TRANSFO, NO_DIR_CHANGE)
CONFT_2 = (2, [(11, ((2, 1), flip_i_0_j_0, flip_d)), (6, NO_CHANGE), (5, TD_CHANGE), (4, TD_CHANGE)])
CONFT_4 = (4, [(5, NO_CHANGE), (10, TD_CHANGE), (11, TD_CHANGE), (2, TD_CHANGE)])
CONFT_5 = (5, [(6, NO_CHANGE), (10, TD_CHANGE), (4, NO_CHANGE), (2, TD_CHANGE)])
CONFT_6 = (6, [(11, ((1, 1), flip_j_0_i_0, incr_d)), (10, NO_CHANGE), (5, NO_CHANGE), (2, NO_CHANGE)])
CONFT10 = (10, [(11, NO_CHANGE), (4, ((-1, -2), flip_j_0,flip_d)), (5, TD_CHANGE), (6, NO_CHANGE)])
CONFT11 = (11, [(4, TD_CHANGE), (2, TD_CHANGE), (10, NO_CHANGE), (6, TD_CHANGE)])

NO_CONF = (None, NO_CHANGE)

TEST_CONF = (
        NO_CONF, NO_CONF, CONFT_2, NO_CONF,
        CONFT_4, CONFT_5, CONFT_6, NO_CONF,
        NO_CONF, NO_CONF, CONFT10, CONFT11)

CONF_01 = (1, [(2, None), (4, None), (6,((2, -1), flip_i_0 ,flip_d)), (9,((3, -1), swap_i_0_j_0, incr_d))])
CONF_02 = (2, [(7, ((2, -1), flip_i_0, flip_d)), (4, ((1, -1), swap_i_0_j_0, incr_d)), (1, None), (9,((3, -2), flip_i_0, NO_DIR_CHANGE))])
CONF_04 = (4, [(2, ((-1, 1), swap_i_0_j_0, decr_d)), (7, None), (6, ((1, -1), swap_i_0_j_0, decr_d)), (1, None)])
CONF_06 = (6, [(7, None), (9, None), (1, ((-2, 1), flip_i_0, flip_d)), (4, ((-1, 1), swap_i_0_j_0, incr_d))])
CONF_07 = (7, [(2, ((-2, 1), flip_i_0, flip_d)), (9, ((1, -1), swap_i_0_j_0, incr_d)), (6, None), (4, None)])
CONF_09 = (9, [(7, ((-1, 1), swap_i_0_j_0, decr_d)), (2, ((-3, 2), flip_i_0, NO_DIR_CHANGE)), (1, ((-3, 1), swap_i_0_j_0, decr_d)), (6, None)])

CONF_4 = (4, [(11,), (6,), (5,), (4,)])
CONF = (NO_CONF, CONF_01, CONF_02,
        NO_CONF, CONF_04, NO_CONF,
        CONF_06, CONF_07, NO_CONF,
        CONF_09, NO_CONF, NO_CONF)


TRACE = {}

def solve_1(grid, commands):
    pos = find_start(grid)
    state = (pos, R)
    for command in commands:
        state = apply_command(grid, state, command)
    row = state[0][0]+1
    col = state[0][1]+1
    d = state[1]
    return 1000*row + col*4 + d


def solve_2(grid, commands):
    pos = find_start(grid)
    state = (pos, R)
    TRACE[pos] = R
    for command in commands:
        state = apply_cube_command(grid, state, command)

    w = max([len(line) for line in grid])
    h = len(grid)
    for i in range(h):
        for j in range(max(w, 16)):
            n = face_n(i, j)
            s = '{}'.format(n)
            conf = CONF[n]
            if (i, j) in TRACE:
                s = ['>', 'v', '<', '^'][TRACE[(i, j)]]
            elif conf[0] is None:
                s = '.'
            else:
                s = '{}'.format(conf[0])
            print(s.rjust(2, ' '), end='')
        print()

    row = state[0][0]+1
    col = state[0][1]+1
    d = state[1]

    return 1000*row + col*4 + d


def face_n(i, j):
    return N_FACE_COLS*(i//FACE_SIZE)+j//FACE_SIZE


def apply_command(grid, state, command):
    pos, d = state
    if 'L' == command:
        d = (d - 1) % 4
    elif 'R' == command:
        d = (d + 1) % 4
    else:
        n = int(command)
        fn = {R: get_next_j, D: get_next_i, L: get_prev_j, U: get_prev_i}[d]
        for _ in range(n):
            i, j = fn(grid, pos[0], pos[1])
            if grid[i][j] == '.':
                pos = (i, j)

    return (pos, d)


def apply_cube_command(grid, state, command):
    w = max([len(line) for line in grid])
    h = len(grid)
    pos, d = state
    if 'L' == command:
        d = (d - 1) % 4
        TRACE[(pos)] = d
    elif 'R' == command:
        d = (d + 1) % 4
        TRACE[(pos)] = d
    else:
        n = int(command)
        for _ in range(n):
            inc_i, inc_j = INCS[d]
            i, j = (pos[0]+inc_i, pos[1]+inc_j)
            if 0 <= i < h and 0 <= j < w:
                if grid[i][j] == '#':
                    continue
                if grid[i][j] == '.':
                    pos = (i, j)
                    TRACE[pos] = d
                    continue
            face_src = face_n(pos[0], pos[1])
            face_dst = face_n(i, j)
            assert face_src != face_dst
            conf = CONF[face_src][1][d]
            t_i, t_j = conf[1][0]
            pos_fn = conf[1][1]
            dir_fn = conf[1][2]
            i_0 = pos[0] % FACE_SIZE
            j_0 = pos[1] % FACE_SIZE
            di = pos[0] - i_0 + t_i*FACE_SIZE
            dj = pos[1] - j_0 + t_j*FACE_SIZE
            i_0, j_0 = pos_fn(i_0, j_0)
            i = di+i_0
            j = dj+j_0
            print(pos, 'f', face_src, face_dst, 'i j', i, j, i_0, j_0, d,'->', d)
            if grid[i][j] == '.':
                pos = (i, j)
                d = dir_fn(d)
                TRACE[pos] = d

    return (pos, d)

def get_next_j(grid, i, j):
    line = grid[i]
    candidate = j + 1
    while True:
        if len(line) <= candidate:
            candidate = 0
        if line[candidate] != ' ':
            break
        candidate += 1
    return (i, candidate)


def get_prev_j(grid, i, j):
    line = grid[i]
    candidate = j - 1
    while True:
        if candidate < 0:
            candidate = len(line)-1
        if line[candidate] != ' ':
            break
        candidate -= 1
    return (i, candidate)


def get_next_i(grid, i, j):
    candidate = i + 1
    while True:
        if len(grid) <= candidate:
            candidate = 0
        if grid[candidate][j] != ' ':
            break
        candidate += 1
    return (candidate, j)


def get_prev_i(grid, i, j):
    candidate = i - 1
    while True:
        if candidate < 0:
            candidate = len(grid)-1
        if grid[candidate][j] != ' ':
            break
        candidate -= 1
    return (candidate, j)


def find_start(grid):
    return get_next_j(grid, 0, 0)


lines = [line[:-1] for line in fileinput.input()]
w = len(lines[0])
if w == 12:
    FACE_SIZE = 4
    N_FACE_COLS = 4
    CONF = TEST_CONF
    w = 16
grid = [line.ljust(w, ' ') for line in lines[:-2]]
commands = re.split(r'([0-9]+)', lines[-1])[1:-1]
print(solve_1(grid, commands))
print(solve_2(grid, commands))
