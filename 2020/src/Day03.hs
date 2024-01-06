module Day03 where

main :: IO ()
main = interact $ show . partTwo . (map cycle) . lines

partOne :: Map -> Int
partOne m = countTrees m (3,1)

partTwo :: Map -> Int
partTwo m = foldl (*) 1 $ map (countTrees m) [(1,1), (3,1), (5,1), (7,1), (1,2)]

type Map = [String]
type Slope = (Int, Int)

countTrees :: Map -> Slope -> Int
countTrees m (dx,dy) = length $ filter (== '#') $ zipWith (!!) rows xs
  where rows = map (m !!) ys
        ys = [0,dy..(length m)-1]
        xs = [0,dx..]
