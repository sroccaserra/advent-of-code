import Data.Maybe (fromJust)
import Data.Set (insert, member)
import qualified Data.Set as Set

import Common (getParsedLines, signed)

main = do
    input <- getParsedLines 1 signed
    print $ partOne input
    print $ partTwo input

partOne = sum

partTwo = fromJust . firstDuplicate . scanl1 (+) . cycle

firstDuplicate :: [Int] -> Maybe Int
firstDuplicate = go Set.empty
  where
    go s (x:xs)
      | member x s = Just x
      | otherwise = go (insert x s) xs
    go _ [] = Nothing
