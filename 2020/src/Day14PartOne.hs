module Day14PartOne where

import Data.Bits
import Data.Char
import qualified Data.Map as M
import Data.List.Split
import Data.Int

main = interact $ show . partOne . parse

parse = map parseMaskAndInstructions . groupByMask
  where groupByMask = map lines . tail . splitOn "mask = "
        parseMaskAndInstructions (x:xs) = (parseMasks x, parseInstructions xs)
        parseMaskAndInstructions _ = error "wrong input"

parseMasks :: String -> MaskPair
parseMasks s = (orMask s, andMask s)
  where orMask = toDec . toIntList . map (xTo '0')
        andMask = toDec . toIntList . map (xTo '1')
        toIntList :: String -> [Int64]
        toIntList = map read . tail . splitOn ""
        xTo r 'X' = r
        xTo _ c = c

parseInstructions :: [String] -> [MemInstruction]
parseInstructions = map (toInstruction . words . map clean)
  where clean c | isDigit c = c
        clean _ = ' '
        toInstruction :: [String] -> MemInstruction
        toInstruction (x:y:_) = (read x, read y)
        toInstruction _ = error "wrong instruction"

partOne = sum . M.elems . foldl applyMaskWithInstructions initMemory

type MaskWithInstructions = (MaskPair, [MemInstruction])
type MaskPair = (Int64, Int64)
type MemInstruction = (Int64, Int64)

type Memory = M.Map Int64 Int64

applyMaskWithInstructions :: Memory -> MaskWithInstructions -> Memory
applyMaskWithInstructions m ((o,a), xs) = updateMemValues m (masked o a xs)
  where masked :: Int64 -> Int64 -> [MemInstruction] -> [MemInstruction]
        masked om am xs = map (\(a,v) -> (a, (om .|. v) .&. am)) xs

updateMemValues :: Memory -> [MemInstruction] -> Memory
updateMemValues m xs = foldl updateMemValue m xs
  where updateMemValue :: M.Map Int64 Int64 -> MemInstruction -> M.Map Int64 Int64
        updateMemValue m (a, v) = M.insert a v m

initMemory :: Memory
initMemory = M.empty

toDec :: [Int64] -> Int64
toDec = foldl1 $ (+) . (*2)
