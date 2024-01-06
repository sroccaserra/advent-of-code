{-# LANGUAGE MonadComprehensions #-}

module Day09 where

import Data.Vector (Vector, (!), fromList, ifilter, slice)

main = interact $ show . partTwo . fromList . (map read) . lines

partOne v = findInvalidNumbers 25 v ! 0

partTwo v = minimum ns + maximum ns
  where ns = head $ head $ filter (/= []) slices
        slices = map (\i -> findContiguousSum v n i) [0..(length v) - 1]
        n = partOne v

findInvalidNumbers n v = ifilter (\i _ -> not $ hasMatchingSum n v $ i+n) candidates
  where candidates = slice n ((length v) - n) v

previousNs :: Int -> Int -> Vector Int -> Vector Int
previousNs n i v = slice (i-n) n v

hasMatchingSum :: Int -> Vector Int -> Int -> Bool
hasMatchingSum n v i = elem (v ! i) sums
  where ns = previousNs n i v
        sums = [i+j | i <- ns, j <- ns]

findContiguousSum v n i = filter ((== n) . sum) $ possibleSlices v i

possibleSlices v i = map (\n -> slice (i-n) (n+1) v) ns
  where ns = [0..i]
