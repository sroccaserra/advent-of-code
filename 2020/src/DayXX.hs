module DayXX where

main = interact $ unlines . (map show) . partOne . (map parseLine) . lines

parseLine = words

partOne = id
