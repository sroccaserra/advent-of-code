module Day21 where

import Data.Char
import Data.List
import Data.Maybe
import Text.ParserCombinators.ReadP
import qualified Data.Map as M

main = interact $ show . partTwo . (map parseLine) . lines

parseLine = fst . last . readP_to_S parser

parser = do
  ingredients <- sepBy1 word spaces
  _ <- string " (contains "
  alergens <- sepBy1 word (string ", ")
  return (ingredients, alergens)

word = munch1 isAlpha
spaces = munch1 isSpace

partOne xs = length $ filter (`elem` alergenFree) $ foldl1 (++) $ map fst xs
  where alergens = nub $ concat $ map snd xs
        ingredients = nub $ concat $ map fst xs
        m = foldl step M.empty xs
        hints = map (\x -> (x,foldl1 intersect $ m M.! x)) alergens
        conversion = map (\(a, [i]) -> (a,i)) $ solve [] hints
        alergenFree = ingredients \\ (map snd conversion)

partTwo xs = intercalate "," $ map snd $ sort conversion
  where alergens = nub $ concat $ map snd xs
        m = foldl step M.empty xs
        hints = map (\x -> (x,foldl1 intersect $ m M.! x)) alergens
        conversion = map (\(a, [i]) -> (a,i)) $ solve [] hints

step m (is, as) = foldl (\acc a -> M.insertWith (++) a [is] acc) m as

solve :: [(String, [String])] -> [(String, [String])] -> [(String, [String])]
solve solved [] = solved
solve solved toSolve = solve (next:solved) (map (removeIngredient solvedI) nextToSolve)
  where next@(_, [solvedI]) = fromJust $ find (\(_,xs) -> (length xs) == 1) toSolve
        nextToSolve = delete next toSolve

removeIngredient :: String -> (String, [String]) -> (String, [String])
removeIngredient i (a, is) = (a, filter (/= i) is)
