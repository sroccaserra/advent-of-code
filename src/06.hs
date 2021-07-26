import Data.List
import Data.Function
import Text.ParserCombinators.ReadP

import Common (getParsedLines, unsigned, Coord(..), boundingBox)

main = do
  input <- getParsedLines 6 point
  print $ partOne input

-- conventions :
-- point = un point reçu en entrée
-- coordonnée = un point x, y dans l'espace

partOne points = maximum $ map length $ group $ sort $ filter (not.isBorder) $ map (snd . head) $ filter ((== 1) . length) $ head . groupBy ((==) `on` fst) . sort <$> distances
  where
    isBorder (Coord x y) = elem x [minX, maxX] || elem y [minY, maxY]
    distances = [[(distance c p, p) | p <- points] | c <- coords]
    coords = [Coord x y | y <- [minY..maxY], x <- [minX..maxX]]
    (Coord minX minY, Coord maxX maxY) = boundingBox points

distance (Coord x1 y1) (Coord x2 y2) = abs (x2 - x1) + abs (y2 - y1)

point :: ReadP Coord
point = Coord <$> unsigned <* string ", " <*> unsigned
