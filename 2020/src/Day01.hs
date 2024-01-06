module Day01 where

import Data.Function

main :: IO ()
main = do
  inputLines <- fmap lines getContents
  print $ inputLines & parse & partTwo

parse :: [String] -> [Int]
parse = map read

partTwo :: [Int] -> Int
partTwo ns =
  snd . head $ filter ((== 2020) . fst) ts
    where ts = do
            x <- ns
            y <- ns
            z <- ns
            return (x+y+z, x*y*z)
