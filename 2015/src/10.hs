import Data.List

partOne s = length $ (iterate next s) !! 40
partTwo s = length $ (iterate next s) !! 50

next :: [Int] -> [Int]
next = concatMap f . group
  where f xs = [length xs, head xs]

---
-- Main and parsing

main = interact $ show.partTwo.parse

parse :: String -> [Int]
parse = map (read . (:[])) . head . lines

---
-- See also:

-- https://fr.wikipedia.org/wiki/Suite_de_Conway

---
-- Other solution from Reddit:

-- import Control.Monad
-- rle  ys = show (length ys) ++ [head ys]
-- nth  n  = length $ iterate (group >=> rle) "1321131112" !! n
-- main    = print (nth 40, nth 50)
