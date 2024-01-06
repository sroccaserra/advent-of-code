module Day12 where

import Data.Complex

main = interact $ show . partTwo . (map parseLine) . lines

parseLine (d:x) = (d, read x ::Float)
parseLine s = error $ "wrong input: " ++ s

partOne :: [(Char, Float)] -> Float
partOne = manhattanDistance . foldl moveShip (1:+0, 0:+0)

partTwo :: [(Char, Float)] -> Float
partTwo = manhattanDistance . foldl moveShip' (10:+1, 0:+0)

manhattanDistance (_, x:+y) = abs x + abs y

j = 0:+1

moveShip (d,p) a = case a of ('N',x) -> (d,  (0:+x) + p)
                             ('S',x) -> (d, -(0:+x) + p)
                             ('E',x) -> (d,  (x:+0) + p)
                             ('W',x) -> (d, -(x:+0) + p)
                             ('F',x) -> (d, (x:+0) * d + p)
                             ('R',x) -> ((-j)^(round x `div` 90)*d, p)
                             ('L',x) -> (j^(round x `div` 90)*d, p)
                             _ -> error "wrong instruction"

moveShip' (w,p) a = case a of ('N',x) -> (w + (0:+x), p)
                              ('S',x) -> (w - (0:+x), p)
                              ('E',x) -> (w + (x:+0), p)
                              ('W',x) -> (w - (x:+0), p)
                              ('F',x) -> (w, (x:+0) * w + p)
                              ('R',x) -> ((-j)^(round x `div` 90)*w, p)
                              ('L',x) -> (j^(round x `div` 90)*w, p)
                              _ -> error "wrong instruction"
