import fileinput
from re import split
from copy import deepcopy


def solve_1(root):
    result = 0
    stack = [root]
    while stack:
        cwd = stack.pop()
        size = cwd['size']
        if size <= 100000:
            result += size
        children = cwd['children']
        for child_name in children:
            stack.append(children[child_name])

    return result


def solve_2(root):
    free_size_needed = 30000000
    max_size = 70000000
    target_size = max_size-free_size_needed
    root_size = root['size']
    to_delete = root_size - target_size
    result = max_size
    stack = [root]
    while stack:
        cwd = stack.pop()
        size = cwd['size']
        if size >= to_delete and size < result:
            result = size
        children = cwd['children']
        for child_name in children:
            stack.append(children[child_name])

    return result


def cd(session, dirname):
    if session.get('root') is None:
        root = create_dir(dirname, None)
        session['root'] = root
        session['cwd'] = root
    elif dirname == '..':
        session['cwd'] = session['cwd']['parent']
    else:
        cwd = session['cwd']
        next_dir = mkdir_p(session, dirname)
        session['cwd'] = next_dir


def create_dir(dirname, parent):
    return {'name': dirname, 'parent': parent, 'children': {}, 'size': 0}


def mkdir_p(session, dirname):
    cwd = session['cwd']
    if dirname in cwd['children']:
        return cwd['children'][dirname]
    new_dir = create_dir(dirname, cwd)
    cwd['children'][dirname] = new_dir
    return new_dir


def process_ls_output_line(session, line):
    words = line.split()
    if words[0] == 'dir':
        mkdir_p(session, words[1])
    else:
        cwd = session['cwd']
        size = int(words[0])
        cwd['size'] += size
        update_parents_sizes(cwd, size)


def update_parents_sizes(directory, size):
    cwd = directory
    while cwd['parent'] is not None:
        cwd = cwd['parent']
        cwd['size'] += size


def describe_file_system_from_logs(logs):
    commands = []
    log_stack = deepcopy(logs)
    log_stack.reverse()
    limit = 10
    while log_stack:
        command = []
        while True:
            command.append(log_stack.pop())

            if len(log_stack) == 0 or log_stack[-1].startswith('$'):
                break;
        commands.append(command)
    session = { 'root': None, 'cwd': None }
    for command in commands:
        instruction = command[0].split()
        if instruction[1] == 'cd':
            cd(session, instruction[2])
        elif instruction[1] == 'ls':
            for line in command[1:]:
                process_ls_output_line(session, line)
        else:
            raise 'Unknown Instruction: ' + instruction[1]
        limit -= 1

    return session['root']


logs = [line.rstrip() for line in fileinput.input()]
root = describe_file_system_from_logs(logs)
print(solve_1(root))
print(solve_2(root))
