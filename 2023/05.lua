local push = table.insert
local pop = table.remove
local unpack = table.unpack

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
  for _, map in ipairs(maps) do
    local new_values = {}
    for _, value in ipairs(values) do
      for _, map_range in ipairs(map) do
        local dst_start, src_start, n = unpack(map_range)
        if src_start <= value and value < src_start + n then
          local inc = dst_start - src_start
          push(new_values, value + inc)
          goto continue
        end
      end
      push(new_values, value)
      ::continue::
    end
    values = new_values
  end

  return min(values)
end

local function solve_2(values, maps)
  -- build value ranges from input
  local value_ranges = {}
  for i=1,#values,2 do
    local start_val = values[i]
    local end_val = start_val + values[i+1]
    push(value_ranges, {start_val, end_val})
  end

  -- see checks on inputs in python version for why this works
  for _, map in ipairs(maps) do
    local new_value_ranges = {}
    while #value_ranges > 0 do
      local value_range = pop(value_ranges)
      local value_start, value_end = unpack(value_range)
      for _, map_range in ipairs(map) do
        local dst_start, src_start, n = unpack(map_range)
        local src_end = src_start + n
        local overlap_start = math.max(src_start, value_start)
        local overlap_end = math.min(src_end, value_end)
        if overlap_start < overlap_end then
          local inc = dst_start - src_start
          push(new_value_ranges, {overlap_start+inc, overlap_end+inc})
          if value_start < overlap_start then
            push(value_ranges, {value_start, overlap_start})
          end
          if overlap_end < value_end then
            push(value_ranges, {overlap_end, value_end})
          end
          goto continue
        end
      end
      push(new_value_ranges, value_range)
      ::continue::
    end
    value_ranges = new_value_ranges
  end

  local mins = {}
  for _, range in ipairs(value_ranges) do
    push(mins, range[1])
  end
  return min(mins)
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
  push(lines, line)
end

local seeds = {}
for word in lines[1]:gmatch('%S+') do
  push(seeds, tonumber(word))
end

local maps = {}
local ranges
for i=2,#lines do
  local line = lines[i]
  if line == '' then
    ranges = {}
    push(maps, ranges)
    goto continue
  end
  local last = line:sub(#line)
  if last == ':' then
    goto continue
  end
  local range = {}
  for word in line:gmatch('%S+') do
    push(range, tonumber(word))
  end
  push(ranges, range)
  ::continue::
end

print(solve_1(seeds, maps))
print(solve_2(seeds, maps))
