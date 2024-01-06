def solve_1(games):
    good_games = [game for game in games if is_good(game)]
    return sum([game[0] for game in good_games])


def solve_2(games):
    powers = [power(game) for game in games]
    return sum(powers)


def is_good(game):
    for grab in game[1]:
        for cube_group in grab:
            nb = cube_group[0]
            color = cube_group[1]
            if color == 'red' and nb > 12:
                return False
            if color == 'green' and nb > 13:
                return False
            if color == 'blue' and nb > 14:
                return False
    return True


def power(game):
    min_r, min_g, min_b = 0, 0, 0
    for grab in game[1]:
        for cube_group in grab:
            nb = cube_group[0]
            color = cube_group[1]
            if color =='red' and nb > min_r:
                min_r = nb
            if color =='green' and nb > min_g:
                min_g = nb
            if color =='blue' and nb > min_b:
                min_b = nb
    return min_r * min_g * min_b


def parse_line(line):
    header_and_parts = line.split(': ')
    game_id = int(header_and_parts[0][5:])
    grabs_string = header_and_parts[1].split('; ')
    return game_id, [[parse_colored_cubes(parts) for parts in gs.split(', ')] for gs in grabs_string]


def parse_colored_cubes(cubes_string):
    parts = cubes_string.split()
    return int(parts[0]), parts[1]


# example = """Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# """[:-1].split('\n')


lines = open(0).read()[:-1].split('\n')
# lines = example

games = [parse_line(line) for line in lines]

print(solve_1(games))
print(solve_2(games))
