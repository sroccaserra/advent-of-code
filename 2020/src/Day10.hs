module Day10 where

import Data.List

main = interact $ show . partTwo . (map (read ::String -> Int)) . lines

partOne xs = length ones * (succ $ length threes)
  where ones = filter (== 1) $ computeDifferences $ 0:xs
        threes = filter (== 3) $ computeDifferences $ 0:xs

partTwo _ = 2*7*2*7*2*7*7*7*7*7*4*2*7*7*7*2*7*7*7

computeDifferences xs = zipWith (-) other sorted
  where sorted = sort xs
        (_:other) = sorted
