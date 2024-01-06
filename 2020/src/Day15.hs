module Day15 where

import Data.List
import Data.List.Split
import qualified Data.IntMap.Strict as M

main = interact $ show . partTwo . parseLine

parseLine :: String -> [Int]
parseLine = map read . splitOn ","

partOne = solve 2020

partTwo = solve 30000000

solve n ns = p where (_,p,_) = foldl' step (initState ns) [1..n - length ns]

type State = (M.IntMap Int, Int, Int)

initState :: [Int] -> State
initState ns = (m, last ns, length ns)
  where m = foldl' f M.empty [0..length ns - 2]
        f a e = M.insert (ns !! e) (e+1) a

step :: State -> Int -> State
step (m,p,i) _ = (M.insert p i m, p', succ i)
  where p' = maybe 0 (\j -> i-j) $ M.lookup p m
