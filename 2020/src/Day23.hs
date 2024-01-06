module Day23 where

import Data.Char
import Data.Maybe
import Text.ParserCombinators.ReadP
import Data.Sequence (Seq(..),(<|),(|>),(><))
import qualified Data.Sequence as Seq
import Data.Foldable (toList)

main = interact $ unlines . (map show) . partTwo . parse

parse s = fst $ last $ readP_to_S parser s

parser :: ReadP [Int]
parser = many1 $ read . (:[]) <$> (satisfy isDigit)

partOne = concatMap show . Seq.drop 1 . alignToOne . last . take 101 . iterate step . Seq.fromList

partTwo xs = toList $ Seq.take 3 $ alignToOne $ last $ take 10000001 $ iterate step extended
  where extended = Seq.fromList $ xs ++ [succ $ length xs..1000000]
-- partTwo xs = map (Seq.take 20) $ take 10 $ iterate step extended
--   where extended = Seq.fromList $ xs ++ [succ $ length xs..1000000]

-- searchCycles i s xs | S.member xs s = (i,xs)
-- searchCycles i s xs | 0 == mod i 1000 = trace (show i) $ searchCycles (succ i) (S.insert xs s) (step xs)
-- searchCycles i s xs = trace (show i) $ searchCycles (succ i) (S.insert xs s) (step xs)

step :: Seq Int -> Seq Int
step seq@(current :<| rest) = Seq.drop 1 (a >< (Seq.take 3 rest) >< c) |> current
  where subList = current <| (Seq.drop 3 rest)
        destIndex = getDestIndex (length seq) current subList
        (a, c) = Seq.splitAt (succ destIndex) subList
step _ = error "list is too small?"

stepWithIndex :: (Int, Seq Int) -> (Int, Seq Int)
stepWithIndex seq@(i, (current :<| rest)) = (i,(a >< (Seq.take 3 rest) >< c))
  where subList = current <| (Seq.drop 3 rest)
        destIndex = getDestIndex (length seq) current subList
        (a, c) = Seq.splitAt (succ destIndex) subList
stepWithIndex _ = error "list is too small?"

getDestIndex :: Int -> Int -> Seq Int -> Int
getDestIndex maxN n subList =
  if elem i' subList then fromJust $ Seq.elemIndexL i' subList else getDestIndex maxN i' subList
  where i = n - 1
        i' = if i == 0 then maxN else i

removeThreeAt :: Int -> Seq Int -> Seq Int
removeThreeAt i xs | (i <= (Seq.length xs - 3)) = (fst $ Seq.splitAt i xs) >< (snd $ Seq.splitAt (i+3) xs)
removeThreeAt i xs = fst $ Seq.splitAt i xs


alignToOne xs = end >< begin
  where i = fromJust $ Seq.elemIndexL 1 xs
        (begin, end) = Seq.splitAt i xs
