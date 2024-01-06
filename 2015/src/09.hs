import Data.Char
import Data.Foldable
import Data.List
import Data.Map (Map, (!))
import Data.Maybe
import qualified Data.Map as Map
import Text.ParserCombinators.ReadP


partOne = solve minimum
partTwo = solve maximum

solve :: ([Int] -> Int) -> [(String, String, Int)] -> Int
solve f xs = f $ map (pathDistance graph) $ permutations cities
  where graph = foldl addToGraph Map.empty xs
        cities = toList $ Map.keysSet graph

addToGraph :: Map String [(String, Int)] -> (String, String, Int) -> Map String [(String, Int)]
addToGraph m (x, y, d) = Map.insertWith (++) x [(y, d)] $ Map.insertWith (++) y [(x, d)] m

distance :: Map String [(String, Int)] -> String -> String -> Int
distance graph a b = fromJust $ lookup b $ graph ! a

pathDistance :: Map String [(String, Int)] -> [String] -> Int
pathDistance graph path = sum $ zipWith (distance graph) path offset
  where offset = drop 1 path

---
-- Parsing and main

parse = map (fst.last.readP_to_S parser) . lines

parser :: ReadP (String, String, Int)
parser = do
  a <- munch1 isAlpha
  string " to "
  b <- munch1 isAlpha
  string " = "
  c <- read <$> munch1 isDigit
  return (a, b, c)

main = interact $ show.partTwo.parse
