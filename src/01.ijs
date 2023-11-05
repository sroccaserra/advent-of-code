load 'src/common/common.ijs'

solve1 =: [: +/2</\ ]
solve2 =: [: solve1 3+/\ ]

numbers =. > ". each getinputlines ''
echo solve1 numbers
echo solve2 numbers

NB. Tests
3 : 0''
  ns =. 199 200 208 210 200 207 240 269 260 263
  assert. 7 -: solve1 ns
  assert. 5 -: solve2 ns
)
