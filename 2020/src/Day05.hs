module Day05 where

main = interact $ show . part2 . lines

part1 = maximum . idNumbers

part2 xs = sum [minimum ns..maximum ns] - sum ns
  where ns = idNumbers xs

idNumbers = map $ toDec . toBin
  where toBin = map $ fromEnum . flip elem "BR"
        toDec = foldl1 $ (+) . (*2)
