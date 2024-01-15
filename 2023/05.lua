local insert = table.insert

local function min(values)
  local result = 9999999999999
  for _, value in ipairs(values) do
    if value < result then
      result = value
    end
  end
  return result
end

local function solve_1(values, maps)
  for _, ranges in ipairs(maps) do
    local new_values = {}
    for _, value in ipairs(values) do
      for _, range in ipairs(ranges) do
        local src_start = range[2]
        local src_end = range[2] + range[3]
        if src_start <= value and value < src_end then
          local inc = range[1] - src_start
          insert(new_values, value + inc)
          goto continue
        end
      end
      insert(new_values, value)
      ::continue::
    end
    values = new_values
  end

  return min(values)
end

local ex = [[seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
]]

local text = ex
-- text = io.input('05'):read('*all')
local lines = {}
for line in text:gmatch('([^\n]*)\n?') do
  insert(lines, line)
end

local seeds = {}
for w in lines[1]:gmatch('%S+') do
  insert(seeds, tonumber(w))
end

local maps = {}
local ranges
for i=2,#lines do
  local line = lines[i]
  if line == '' then
    ranges = {}
    insert(maps, ranges)
    goto continue
  end
  local last = line:sub(#line)
  if last == ':' then
    goto continue
  end
  local range = {}
  for w in line:gmatch('%S+') do
    insert(range, tonumber(w))
  end
  insert(ranges, range)
  ::continue::
end

print(solve_1(seeds, maps))
