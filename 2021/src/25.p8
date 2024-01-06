pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
-- main

local floor = {
'v...>>.vv>',
'.vv>>.vv..',
'>>.>v>...v',
'>>v>>.>.v.',
'v>v.vv.v..',
'>.>>..v...',
'.vv..>.>v.',
'v.v..>>v.v',
'....v..v.>',
}

local n
local w
local h
local easts
local souths
local done
local fc

function _init()
  fc = 0
  done = false
  n = 0
  w = #floor[1]
  h = #floor
  easts = {}
  souths = {}
  
  for y=1,h do
    row = floor[y]
    for x=1,w do
      c = sub(row,x,x)
      if c == '>' then
        set(easts, x, y)
      elseif c == 'v' then
        set(souths, x, y)
      end
    end
  end
end

function _draw()
  fc = fc + 1
  cls()
  map()

  display(w, h, easts, souths)

  x_p = 60
  y_p = 104
  print(n, x_p+1, y_p+1, 8)
  print(n, x_p, y_p, 10)
end

function _update()
  if fc % 2 ~= 0 then
    return
  end
  if not done then
    n = n + 1
    easts, souths, moved = step(w, h, easts, souths)
  end
  if not moved then
    done = true
  end
end

-->8
-- display

function display(w, h, easts, souths)
  for y=1,h do
    local row = ''
    for x=1,w do
      local c
      x_screen = (x-1)*8 + 24
      y_screen = (y-1)*8 + 24
      if get(easts, x, y) then
        c = '>'
        spr(1,x_screen,y_screen)
      elseif get(souths, x, y) then
        c = 'v'
        spr(2,x_screen,y_screen)
      else
        c = '.'
        spr(3, x_screen,y_screen)
      end
      row = row..c
    end
--    print(row)
  end
end

-->8
-- step

function step(w, h, easts, souths)
  local moved = false
  local new_easts = {}
  for y in pairs(easts) do
    for x in pairs(easts[y]) do
      dest_x = east_of(w, x)
      if is_occupied(easts, souths, dest_x, y) then
        set(new_easts, x, y)
      else
        moved = true
        set(new_easts, dest_x, y)
      end
    end
  end

  local new_souths = {}
  for y in pairs(souths) do
    for x in pairs(souths[y]) do
      dest_y = south_of(h, y)
      if is_occupied(new_easts, souths, x, dest_y) then
        set(new_souths, x, y)
      else
        moved = true
        set(new_souths, x, dest_y)
      end
    end
  end
  return new_easts, new_souths, moved
end

-->8
-- tools

function is_occupied(easts, souths, x, y)
  return get(easts, x, y) or get(souths, x, y)
end

function east_of(w, x)
  if x == w then return 1 else return x + 1 end
end

function south_of(h, y)
  if y == h then return 1 else return y + 1 end
end

function set(t,x,y)
  if not t[y] then
    t[y] = {}
  end
  t[y][x] = true
end

function get(t,x,y)
  return t[y] and t[y][x]
end

__gfx__
00000000cc000000800000e000000000000000000000000000000000003bba000abbbb300abbbb30000300000000000000ccc000b3000000000000b300000000
000000000c7c000088eeee800000000000aaaaaa000000000aaaa000003bbb000abbbb3a33bbbb30000300000cc000000c077c00b3000000000000b300000000
007007000dc77c0002888e000000000000bbbbbbaaaaaaabbbbbba00003bba000abbbbbbbbbbbb3000300b00c07c00000c0c7c00b3000000000000b3aaaaaaab
000770000dccc77c088888000003b0000bbbbbbbbbbbbbbbbbb3bba000b3ba000abbbbbbbbbbbb300300b000c00c00000c000c00b3000000000000b3bbbbbbbb
000770000cccdd000028e0000003300003bbbbbbbbb333bbbbab3ba000b3ba000abbbbbbbbbbbbb00300b0000cc0000000ccc000b3000000000000b3bbb333bb
0070070007dd0000008280000000000003bbbbbb33333333bbbabba0003bba000abbbbbbbbbbbb0003000b000000000000000000b3000000000000b333333333
00000000cd000000000200000000000003bbbb330000000003bbbba0003bba00000b3333aaaaaa0000300b000000000000000000bb30000000000bb3000000b3
0000000000000000000800000000000003bbbba00000000000bbba00003bba00000000000000000000030b0000000000000000000bbbbbbbbbbbbb30000000b3
000000000000000000000000000000000000000000000000000000000000000000000000000000000000b0000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000b03000000000000000000000000000000000000000000
aaaaaaab00000000000000000000000000000000000000000000000000000000000000000000000000b003000000000000000000000000000000000000000000
bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000b003000000000000000000000000000000000000000000
bbb333bb00000000000000000000000000000000000000000000000000000000000000000000000000b030000000000000000000000000000000000000000000
33333333000000000000000000000000000000000000000000000000000000000000000000000000000300000000000000000000000000000000000000000000
b30000000000000000000000000000000000000000000000000000000000000000000000000000000030b0000000000000000000000000000000000000000000
b3000000000000000000000000000000000000000000000000000000000000000000000000000000003bb0000000000000000000000000000000000000000000
__map__
00000b0000000000000b00000c00000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a00000000000c00000000000000001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a00040505050505050505050506000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000070000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000070000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a070000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001a0700000000000000000000070b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000070000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000070000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b000700000000000000000000070a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000700000000000000000000071a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a00070000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1a000805050505100f0505050509000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000c00000d0e000c000000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
