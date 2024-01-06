{-# LANGUAGE OverloadedStrings #-}

module Day07 where

import Data.Maybe
import Data.List.Split

main = interact $ show . partTwo . (map parseLine) . lines

parseLine :: String -> Rule
parseLine = parseQuantities . splitOn ":"

parseQuantities :: [String] -> Rule
parseQuantities xs = ((xs !! 0), qs)
  where qs = (filter $ (/= 0) . snd) $ map parseQuantity $ splitOn "," $ xs !! 1

parseQuantity :: String -> Quantity
parseQuantity "" = ("", 0)
parseQuantity x = (ws !! 1, read (ws !! 0))
  where ws = words x

partOne m = sum $ map (\(s,_) -> fromEnum $ containShinyGold m s) m

partTwo m = (countBags m $ findQuantities m "shiny_gold") - 1

type Quantity = (String, Int)
type Rule = (String, [Quantity])

containShinyGold :: [Rule] -> String -> Bool
containShinyGold m s | isJust $ lookup "shiny_gold" $ findQuantities m s = True
containShinyGold m s | [] == findQuantities m s = False
containShinyGold m s = any (containShinyGold m) xs
  where xs = map fst $ findQuantities m s

countBags :: [Rule] -> [Quantity] -> Int
countBags _ [] = 1
countBags m qs = succ $ foldl acc 0 qs
  where acc a (s, n) = a + n * (countBags m (findQuantities m s))

findQuantities m s = fromMaybe [] $ lookup s m
