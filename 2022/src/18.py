import fileinput
from collections import Counter, deque
from copy import deepcopy


def solve_1(cubes):
    return len(exposed_faces(cubes))


def solve_2(cubes):
    cubes = deepcopy(cubes)
    min_x = 9999
    max_x = 0
    min_y = 9999
    max_y = 0
    min_z = 9999
    max_z = 0
    for (x, y, z) in cubes:
        min_x = min(x, min_x)
        min_y = min(y, min_y)
        min_z = min(z, min_z)
        max_x = max(x, max_x)
        max_y = max(y, max_y)
        max_z = max(z, max_z)
    for z in range(min_z, max_z+1):
        for y in range(min_y, max_y+1):
            for x in range(min_x, max_x+1):
                src = (x, y, z)
                if src in cubes:
                    continue
                bubble = bubble_maybe(cubes, min_x, max_x, min_y, max_y, min_z, max_z, src)
                if len(bubble) > 0:
                    cubes |= bubble
    return solve_1(cubes)


def bubble_maybe(cubes, min_x, max_x, min_y, max_y, min_z, max_z, src):
    q = deque([src])
    visited = set()
    while q:
        node = deque.popleft(q)
        visited.add(node)
        for (x, y, z) in free_neighbors(cubes, node):
            if x<min_x or max_x < x or y < min_y or max_y < y or z < min_z or max_z < z:
                return set()
            if (x, y, z) not in visited:
                q.append((x, y, z))
    return visited


def free_neighbors(cubes, cube):
    (x, y, z) = cube
    result = set()
    for (dx, dy, dz) in [(-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0,0,-1), (0, 0, 1)]:
        n = (x+dx, y+dy, z+dz)
        if n not in cubes:
            result.add(n)
    return result


def exposed_faces(cubes):
    face_counter = Counter()
    for cube in cubes:
        new_faces = faces(cube)
        face_counter.update(faces(cube))
    result = set()
    for (face, cnt) in face_counter.items():
        if cnt == 1:
            result.add(face)
    return result


def faces(cube):
    (x, y, z) = cube
    return set([(cube, 'up'), (cube, 'right'), (cube, 'front'),
            ((x, y-1, z), 'up'), ((x-1, y, z), 'right'), ((x, y, z+1), 'front')])


cubes = set([tuple([int(w) for w in line.strip().split(',')]) for line in fileinput.input()])
print(solve_1(cubes))
print(solve_2(cubes))
