import Data.List
import Data.Char
import qualified Data.Set as Set
import Text.ParserCombinators.ReadP

import Common (getParsedLines, unsigned)

main = do
  input <- getParsedLines 8 parser
  print $ partOne input
  print $ partTwo input

partOne signals = length $ filter ((`elem` wanted) . length) outputs
  where outputs = concatMap snd signals
        wanted = [2, 3, 4, 7]

partTwo signals = sum $ map solveSignal signals

solveSignal (patterns, output) = 1000*m + 100*c + 10*d + n
  where [p_1, p_4, p_7] = map (knownPattern patterns) [2, 4, 3]
        digitFor p | length p == 2 = 1
        digitFor p | length p == 4 = 4
        digitFor p | length p == 3 = 7
        digitFor p | length p == 7 = 8
        digitFor p | length p == 6 && p == Set.union p_4 p = 9
        digitFor p | length p == 6 && p == Set.union p_7 p = 0
        digitFor p | length p == 6 = 6
        digitFor p | p == Set.union p_7 p = 3
        digitFor p | 2 == length (Set.intersection p_4 p) = 2
        digitFor p = 5
        [m, c, d, n] = map digitFor output

knownPattern patterns n = head $ filter ((== n) . length) patterns

parser = (,) <$> (sets <* (string " | ")) <*> sets
  where sets = map Set.fromList . words <$> many1 get
