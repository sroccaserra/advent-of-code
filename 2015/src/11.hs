import Data.List
import Data.Char
import Data.Maybe
import Numeric

partOne = until isCorrect next

partTwo p1 = until isCorrect next (next p2)
  where p2 = until isCorrect next p1

chars = "abcdefghijklmnopqrstuvwxyz"

next = toPassword . succ . fromPassword

fromPassword = fst . last . (readInt (length chars) (`elem` chars) charToInt)

toPassword n = showIntAtBase (length chars) (chars !!) n ""

charToInt = fromJust . (`elemIndex` chars)

isCorrect :: String -> Bool
isCorrect p = satisfiesRule1 ords && satisfiesRule2 p && satisfiesRule3 p
  where ords = map ord p

satisfiesRule1 ords = any (\[a, b, c] -> a + 1 == b && b + 1 == c) by3
  where by3 = byN 3 ords
satisfiesRule2 = not . any (`elem` "iol")
satisfiesRule3 p = 2 <= (length $ nub dups)
  where by2 = byN 2 p
        dups = filter (\[x, y] -> x == y) by2

byN n xs = zipWith const (take n <$> tails xs) (drop (n-1) xs)

---
-- Main & parsing

main = interact $ show.partTwo.parse

parse = head.lines
