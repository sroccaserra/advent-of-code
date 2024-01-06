local function print_points(visited, rope)
    local x_min = 99999
    local x_max = 0
    local y_min = 99999
    local y_max = 0
    for k,_ in pairs(visited) do
      local a, b = string.match(k, "(-?%d+)_(-?%d+)")
      local x = tonumber(a)
      local y = tonumber(b)
      if x < x_min then x_min = x end
      if x_max < x then x_max = x end
      if y < y_min then y_min = y end
      if y_max < y then y_max = y end
    end
    for i=1,#rope do
      local node = rope[i]
      local x = node[1]
      local y = node[2]
      if x < x_min then x_min = x end
      if x_max < x then x_max = x end
      if y < y_min then y_min = y end
      if y_max < y then y_max = y end
    end
    for y=y_max,y_min, -1 do
      for x=x_min,x_max do
        local c = '.'
        local key = string.format("%d_%d", x, y)
        if visited[key] then c = '#' end
        io.write(c)
      end
      print()
    end
end

local function up(head)
  head[2] = head[2]+1
end

local function down(head)
  head[2] = head[2]-1
end

local function left(head)
  head[1] = head[1]-1
end

local function right(head)
  head[1] = head[1]+1
end

-- local commands = {
--   {'R', 5},
--   {'U', 8},
--   {'L', 8},
--   {'D', 3},
--   {'R', 17},
--   {'D', 10},
--   {'L', 25},
--   {'U', 20},
-- }

local actions = {U = up, D = down, L = left, R = right}

local function follow(h, t)
  local xh = h[1]
  local yh = h[2]
  local xt = t[1]
  local yt = t[2]
  if math.abs(xh -xt) > 1 and math.abs(yh - yt) > 1 then
    t[1] = t[1] + (xh -xt)/2
    t[2] = t[2] + (yh -yt)/2
  elseif math.abs(xh - xt) > 1 then
    t[1] = t[1] + (xh - xt)/2
    t[2] = yh
  elseif math.abs(yh -yt) > 1 then
    t[1] = xh
    t[2] = t[2] + (yh - yt)/2
  end
end

local function solve(rope, commands)
  local visited = {}
  for i=1, #commands do
    local command = commands[i]
    local action = actions[command[1]]
    for _=1,command[2] do
      action(rope[1])
      for j = 2, #rope do
        follow(rope[j-1], rope[j])
      end
      local tail = rope[#rope]
      local key = string.format("%d_%d", tail[1], tail[2])
      visited[key] = true
    end
  end
  local result = 0
  for _ in pairs(visited) do
    result = result + 1
  end
  -- print_points(visited, rope)
  return result
end

local commands = {}

while true do
  local line = io.read("*line")
  if not line then break end
  local a, v = string.match(line, "(%w+) (%d+)")
  table.insert(commands, {a, tonumber(v)})
end

print(solve({{0, 0}, {0, 0}}, commands))
print(solve({{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}, commands))
