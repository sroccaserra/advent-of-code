import fileinput


def parse(words):
    word = words[0]
    if word =='value':
        return (int(words[1]),int(words[5]))
    return (int(words[1]), (words[5], int(words[6])), (words[10], int(words[11])))


def solve(instructions):
    insts = instructions
    bots = {}
    outs = {}
    while insts:
        next_insts = []
        for inst in insts:
            apply(inst, bots, outs, next_insts)
        insts = next_insts
    print(outs[0][0]*outs[1][0]*outs[2][0])


def apply(inst, bots, outs, next_insts):
    if 2 == len(inst):
        n = inst[1]
        dst = bots.setdefault(n,[])
        dst.append(inst[0])
    else:
        n = inst[0]
        src = bots.setdefault(n, [])
        if 2 == len(src):
            if(sorted(src) == [17, 61]):
                print(n)
            low_dst_inst = inst[1]
            if low_dst_inst[0] == 'bot':
                n_low = low_dst_inst[1]
                low_dst = bots.setdefault(n_low, [])
            else:
                low_dst = outs.setdefault(low_dst_inst[1], [])
            low_dst.append(min(src))

            high_dst_inst = inst[2]
            n_high = high_dst_inst[1]
            if high_dst_inst[0] == 'bot':
                high_dst = bots.setdefault(n_high, [])
            else:
                high_dst = outs.setdefault(n_high, [])
            high_dst.append(max(src))

            bots[n] = []
        else:
            next_insts.append(inst)


instructions = [parse(line.strip().split()) for line in fileinput.input()]
solve(instructions)
