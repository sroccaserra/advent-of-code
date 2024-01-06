module Day04 where

import Data.Char
import Data.List

main :: IO ()
main = interact $ show . partTwo . (map parseLine) . lines

parseLine :: String -> Passport
parseLine s =
  Passport (read $ values !! 0) (values !! 1) (read $ values !! 2) (values !! 3) (values !! 4) (read $ values !! 5) (values !! 6)
  where values = map (snd . splitAt 4) sortedWords
        sortedWords = sort $ filter (not.isCid) $ words s
        isCid ('c':_) = True
        isCid _ = False

partTwo :: [Passport] -> Int
partTwo ps = length $ filter isValid ps

data Passport = Passport Int String Int String String Int String
              deriving (Show)

isValid :: Passport -> Bool
isValid (Passport byr ecl eyr hcl hgt iyr pid) =
  isByrValid byr && isEclValid ecl && isEyrValid eyr && isHclValid hcl &&
  isHgtValid hgt && isIyrValid iyr && isPidValid pid

isByrValid :: Int -> Bool
isByrValid n = 1920 <= n && n <= 2002
isEyrValid :: Int -> Bool
isEyrValid n = 2020 <= n && n <= 2030
isIyrValid :: Int -> Bool
isIyrValid n = 2010 <= n && n <= 2020

isEclValid :: String -> Bool
isEclValid ecl = elem ecl ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

isHclValid :: String -> Bool
isHclValid ('#':s) = length s == 6 && all isHexDigit s
isHclValid _ = False

isHgtValid :: String -> Bool
isHgtValid hgt = elem u ["cm", "in"] && ok (read s ::Int) u
  where (s, u) = span isDigit hgt
        ok n "cm" = 150 <= n && n <= 193
        ok n "in" = 59 <= n && n <= 76
        ok _ _ = False

isPidValid :: String -> Bool
isPidValid s = length s == 9 && all isDigit s
