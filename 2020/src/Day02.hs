module Day02 where

import Data.Char
import Data.Function
import Data.Maybe
import Text.ParserCombinators.ReadP

main :: IO ()
main = do
  inputLines <- fmap lines getContents
  print $ inputLines & map parseLine & partTwo

partOne :: [PasswordInfo] -> Int
partOne = length . filter isValidPartOne

isValidPartOne :: PasswordInfo -> Bool
isValidPartOne (PasswordInfo n1 n2 c p) = n1 <= n && n <= n2
  where n = p & filter (== c) & length

partTwo :: [PasswordInfo] -> Int
partTwo = length . filter isValidPartTwo

isValidPartTwo :: PasswordInfo -> Bool
isValidPartTwo (PasswordInfo n1 n2 c p) =
  (c1 == c && c2 /= c) || (c1 /= c && c2 == c)
  where
    c1 = p !! (n1-1)
    c2 = p !! (n2-1)

data PasswordInfo = PasswordInfo Int Int Char String
                  deriving (Show, Eq)

parseLine :: String -> PasswordInfo
parseLine s = PasswordInfo (read w) (read x) (head y) z
  where [w, x, y, z] = s & map clean & words
        clean c | isAlphaNum c = c
                | otherwise = ' '

---
-- Working but unused, written to learn parser combinators.

parseLineReadP :: String -> PasswordInfo
parseLineReadP x = fromMaybe (PasswordInfo 0 0 ' ' "") p
  where p = case reverse allMatches of
                 [] -> Nothing
                 ((bestMatch, _):_) -> Just bestMatch
        allMatches = readP_to_S parser x
        parser = do
          n1 <- int
          skipMany1 $ char '-'
          n2 <- int
          skipSpaces
          c <- get
          _ <- string ": "
          s <- letters
          eof
          return $ PasswordInfo n1 n2 c s

int :: ReadP Int
int = fmap read $ many1 $ satisfy isDigit

letters :: ReadP String
letters = many1 $ satisfy isAlpha
