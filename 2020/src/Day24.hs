module Day24 where

import Control.Applicative
import Data.List
import Data.Map (Map, (!?))
import qualified Data.Map as Map
import Data.Maybe
import Text.ParserCombinators.ReadP

type Path = [Direction]
data Direction = E | SE | SW | W | NW | NE
               deriving (Show,Eq,Enum,Bounded)

type Grid = Map Tile Color
type Tile = (Int,Int,Int)
data Color = Black | White
           deriving (Show,Eq)

main = interact $ show . partTwo . (map parseLine) . lines

partOne :: [Path] -> Int
partOne = Map.size . initialGrid

followPath t xs = foldl move t xs

move (x,y,z) E = (x+1,y-1,z)
move (x,y,z) SE = (x,y-1,z+1)
move (x,y,z) SW = (x-1,y,z+1)
move (x,y,z) W = (x-1,y+1,z)
move (x,y,z) NW = (x,y+1,z-1)
move (x,y,z) NE = (x+1,y,z-1)

partTwo = count . last . take 101 . iterate step . initialGrid
  where count = Map.size . Map.filter (== Black)

initialGrid :: [Path] -> Grid
initialGrid xs = Map.fromList $ map (\x -> (x,Black)) blackTiles
  where blackTiles = map fst $ filter (odd . snd) $ uniqCount $ map (followPath (0,0,0)) xs

step :: Grid -> Grid
step g = Map.filter (== Black) $ foldl (stepTile g) g $ tilesToEvolve g

stepTile g g' t = Map.insert t newColor g'
  where nbBlacks = length $ filter (== Black) $ map (color g) (neighbors t)
        newColor = evolve (color g t) nbBlacks

tilesToEvolve :: Grid -> [Tile]
tilesToEvolve g = union (concatMap neighbors blackTiles) blackTiles
  where blackTiles = Map.keys $ Map.filter (== Black) g

neighbors :: Tile -> [Tile]
neighbors t = map (move t) [(minBound ::Direction)..]

evolve :: Color -> Int -> Color
evolve Black n = if 0 == n || n > 2 then White else Black
evolve White n = if n == 2 then Black else White

color :: Grid -> Tile -> Color
color g t = fromMaybe White (g !? t)

---
-- Parsing

parseLine :: String -> [Direction]
parseLine = fst . last . readP_to_S (many1 parser)

parser :: ReadP Direction
parser = direction <$> choice [string "e", string "se", string "sw", string "w", string "nw", string "ne"]

direction "e" = E
direction "se" = SE
direction "sw" = SW
direction "w" = W
direction "nw" = NW
direction "ne" = NE
direction _ = error "wrong direction char"

---
-- sort | uniq -c equivalent

uniqCount :: Ord a => [a] -> [(a, Int)]
uniqCount = map lh . sg

lh :: [a] -> (a, Int)
lh = liftA2 (,) head length

sg :: Ord a => [a] -> [[a]]
sg = group . sort
