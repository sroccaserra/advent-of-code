module Day13 where

import Control.Monad (zipWithM)
import Data.List.Split

main = putStrLn $ show partTwo

parseInput :: [String] -> (Int, [Int])
parseInput (x:y:_) = (read x ::Int, map read xs)
  where xs = filter (/= "x") $ splitOn "," y
parseInput _ = error "wrong input"

partOne (n,ns) = diffs
  where diffs = map (\x -> x - (rem n x)) ns

buildInput (x:y:n:[]) = (read x, read y,read n)
buildInput _ = error "wrong input"

partTwo :: Either String Int
partTwo = chineseRemainder [19, 37, 599, 29, 17, 23, 761, 41, 13]
                           [ 0, 37-13,  599-19, 29-21, 2*17-36, 2*23-42,  761-50, 2*41-60, 5*13-63]

-- https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
-- Returns u and v such that au + bv = gcd(a, b)
egcd :: Int -> Int -> (Int, Int)
egcd _ 0 = (1, 0)
egcd a b = (t, s - q * t)
  where
    (s, t) = egcd b r
    (q, r) = a `quotRem` b

-- https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
modInv :: Int -> Int -> Either String Int
modInv a b =
  case egcd a b of
    (x, y)
      | a * x + b * y == 1 -> Right x
      | otherwise ->
        Left $ "No modular inverse for " ++ show a ++ " and " ++ show b

-- https://en.wikipedia.org/wiki/Chinese_remainder_theorem
chineseRemainder :: [Int] -> [Int] -> Either String Int
chineseRemainder modulii residues =
  zipWithM modInv crtModulii modulii >>=
  (Right . (`mod` modPI) . sum . zipWith (*) crtModulii . zipWith (*) residues)
  where
    modPI = product modulii
    crtModulii = (modPI `div`) <$> modulii
