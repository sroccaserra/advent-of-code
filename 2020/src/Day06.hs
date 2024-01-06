{-# LANGUAGE OverloadedStrings #-}

module Day06 where

import Data.List
import Data.Bifunctor
import qualified Data.Text as T

main = interact $ show . bimap partOne partTwo . dup . parseInput
  where dup x = (x,x)

parseInput = map lines . map T.unpack . T.splitOn "\n\n" . T.pack

partOne = sum . (map $ length . foldl1 union)

partTwo = sum . (map $ length . foldl1 intersect)
