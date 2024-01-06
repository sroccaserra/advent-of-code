module Day16 where

import Control.Applicative
import Data.Char
import Data.List.Split

main = interact $ unlines . (map show) . partTwo . parse

parse xs = (map parseRule a, map parseTicket $ tail $ init c)
  where (a:_:c:_) = map (splitOn "\n") $ splitOn "\n\n" xs

parseRule s = (label , map read $ words $ map clean xs ::[Int])
  where parts = splitOn ":" s
        [label,xs] = parts
        clean c | isDigit c = c
        clean _ = ' '

parseTicket :: String -> [Int]
parseTicket = map read . splitOn ","

partOne (rules,tickets) = sum $ concat $ map (checkTicket rules) tickets

partTwo (rules,tickets) = map (map fst) $ map (matchingRules rules) columns
  where columns = transpose $ validTickets rules tickets

checkTicket rs xs = filter (not . matchesAnyRule rs) xs

matchesAnyRule rs x = any (flip matchesRule x) rs

matchesRule (_,[a1,b1,a2,b2]) x = (a1 <= x && x <= b1) || (a2 <= x && x <= b2)
matchesRule _ _ = error "wrong input"

validTickets rs xs = filter (all $ matchesAnyRule rs) xs

matchingRules rs xs = filter (\r -> all (matchesRule r) xs) rs

transpose :: [[a]] -> [[a]]
transpose = getZipList . traverse ZipList
