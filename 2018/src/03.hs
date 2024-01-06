module Day03 where

import Data.Function
import Text.ParserCombinators.ReadP
import qualified Data.Map as M

import Common (getParsedLines, unsigned)

main = do
  input <- getParsedLines 3 parser
  print $ partOne input
  print $ partTwo input

partOne :: [Claim] -> Int
partOne claims = M.size $ M.filter (> 1) fabric
  where
    fabric = foldr addPoints M.empty claims

partTwo :: [Claim] -> [Claim]
partTwo claims = filter (hasNoCollision fabric) claims
  where
    fabric = foldr addPoints M.empty claims

hasNoCollision :: Fabric -> Claim -> Bool
hasNoCollision f = (== 1) . foldr max 0 . heights f

parser :: ReadP Claim
parser = do
  char '#'
  n <- unsigned
  string " @ "
  x <- unsigned
  char ','
  y <- unsigned
  string ": "
  w <- unsigned
  char 'x'
  h <- unsigned
  return $ Claim n x y (x+w-1) (y+h-1)

data Claim = Claim {
  i :: Int,
  x1 :: Int,
  y1 :: Int,
  x2 :: Int,
  y2 :: Int
} deriving (Show)

type Point = (Int, Int)
type Points = [Point]

type Fabric = M.Map Point Int

points :: Claim -> Points
points r = do
  x <- [x1 r..x2 r]
  y <- [y1 r..y2 r]
  return (x, y)

addPoints :: Claim -> Fabric -> Fabric
addPoints c f = foldr addPoint f $ points c

addPoint :: Point -> Fabric -> Fabric
addPoint p f =
  M.alter (Just . maybe 1 succ) p f

heights :: Fabric -> Claim -> [Int]
heights f c = [maybe 0 id $ M.lookup y f | y <- ps]
  where ps = points c
