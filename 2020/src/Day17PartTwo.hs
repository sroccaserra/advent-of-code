module Day17PartTwo where

import Data.List
import qualified Data.Map.Strict as M

main = interact $ show . partTwo . parse

parse s = (foldl acc M.empty coords,(-1,-1,-1,-1),(w,h,1,1))
  where initialGrid = lines s
        w = length $ head initialGrid
        h = length initialGrid
        coords = [(x,y,0,0) | x <- [0..w-1], y <- [0..h-1]]
        acc m p@(x,y,_,_) | '#' == lookup x y = M.insert p True  m
        acc m _ = m
        lookup x y = (initialGrid !! y) !! x

partTwo st = length $ M.keys $ M.filter id m
-- partOne st@(_,l@(_,_,z_l),h@(_,_,z_h)) = show l : show h : (intercalate [""] $ map (printLayer st') [z_l..z_h])
  where st'@(m,_,_) = last $ take 7 $ iterate step st

printLayer :: State -> Int -> Int ->  [String]
printLayer (m,(x_l,y_l,_,_),(x_h,y_h,_,_)) z w = map (\y -> map (\x -> char (x,y,z,w)) [x_l..x_h] ) [y_l..y_h]
  where char p = toChar $ M.findWithDefault False p m
        toChar True = '#'
        toChar False = '.'

type State = (M.Map Point Bool, Point, Point)
type Point = (Int,Int,Int,Int)

step :: State -> State
step st@(m,(x_l,y_l,z_l,w_l),(x_h,y_h,z_h,w_h)) = foldl' (updatePoint m) st points
  where points = [(x,y,z,w) | x <- [x_l..x_h], y <- [y_l..y_h], z <- [z_l..z_h], w <- [w_l..w_h]]

updatePoint m st p = if (newState m p)
                        then activatePoint st p
                        else deactivatePoint st p

newState m p = if v then (2 <= n && n <= 3) else n == 3
  where n = nbActive m p
        v = M.findWithDefault False p m

activatePoint (m,l,h) p = (M.insert p True m, updateLow l p, updateHigh h p)
deactivatePoint (m,l,h) p = (M.insert p False m, l, h)

nbActive m p = length $ filter id ns
  where ns = map (\n -> M.findWithDefault False n m) (neighbours p)

updateLow (x_l,y_l,z_l,w_l) (x,y,z,w) =
  (if x == x_l then (x_l-1) else x_l
  ,if y == y_l then (y_l-1) else y_l
  ,if z == z_l then (z_l-1) else z_l
  ,if w == w_l then (w_l-1) else w_l)

updateHigh (x_h,y_h,z_h,w_h) (x,y,z,w) =
  (if x == x_h then (x_h+1) else x_h
  ,if y == y_h then (y_h+1) else y_h
  ,if z == z_h then (z_h+1) else z_h
  ,if w == w_h then (w_h+1) else w_h)

neighbours (x,y,z,w) = [(x',y',z',w') | x' <- [x-1,x,x+1], y' <- [y-1,y,y+1], z' <- [z-1,z,z+1], w' <- [w-1,w,w+1], (x',y',z',w') /= (x,y,z,w)]
