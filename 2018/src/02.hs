import Data.Char
import Data.List
import Data.Maybe

import Common (getDayLines)

main = do
  input <- getDayLines 2
  print $ partOne input
  putStrLn $ partTwo input

partOne boxIds = numberOfSame 2 boxIds * numberOfSame 3 boxIds
  where
    numberOfSame n = length . filter id . map (hasNSames n)
    hasNSames n = isJust . find (== n) . map length . group . sort

partTwo boxIds = matching a b
  where
    matching (x:xs) (y:ys)
      | x == y = x:matching xs ys
      | otherwise = matching xs ys
    matching _ _ = []
    (a, b) = paired !! diffOfOne
    Just diffOfOne = elemIndex 1 diffs
    diffs = map (\(s1, s2) -> length $ filter (/= 0) $ zipWith (\c1 c2 -> ord c1 - ord c2) s1 s2) paired
    paired = zip sortedIds (tail sortedIds)
    sortedIds = sort boxIds
