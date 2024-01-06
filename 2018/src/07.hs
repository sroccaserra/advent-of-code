import Data.Array ((//), (!))
import Data.Char (chr, ord)
import Data.Graph
import Text.ParserCombinators.ReadP

import Common (getParsedLines)

main = do
  input <- getParsedLines 7 parser
  putStrLn $ partOne input

partOne input = map chr $ fst $ (iterate step ([], g)) !! 26
  where
    g = buildG (minVertex, maxVertex) input
    minVertex = ord 'A'
    maxVertex = ord 'Z'

step :: ([Vertex], Graph) -> ([Vertex], Graph)
step (is, g) = (is ++ [next], g' // [(next, done)])
  where
    next = findNext g
    g' = filter (/= next) <$> g
    done = [-1]

findNext :: Graph -> Vertex
findNext g = head [i | i <- vertices g, [] == g ! i]

parser :: ReadP Edge
parser = do
  b <- string "Step " *> get
  a <- string " must be finished before step " *> get
  return (ord a, ord b)
