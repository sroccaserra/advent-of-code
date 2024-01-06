module Day14PartTwo where

import Data.Bits
import Data.Char
import qualified Data.Map as M
import Data.List
import Data.List.Split
import Data.Int

main = interact $ show . partTwo . parse

parse = map parseMaskAndInstructions . groupByMask
  where groupByMask = map lines . tail . splitOn "mask = "
        parseMaskAndInstructions (x:xs) = (parseMasks x, parseInstructions xs)
        parseMaskAndInstructions _ = error "wrong input"

parseMasks :: String -> MaskPair
parseMasks s = (orMask s, xMask s)
  where orMask = toDec . toIntList . map (xTo '0')
        xMask = id
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

partTwo = sum . M.elems . foldl applyMaskWithInstruction M.empty

type Memory = M.Map Int64 Int64

type Patch = [BitPatch]
type BitPatch = (Int,Int64)

type BitList = [Int64]

type MaskWithInstructions = (MaskPair, [MemInstruction])
type MaskPair = (Int64, String)
type MemInstruction = (Int64, Int64)

applyMaskWithInstruction :: Memory ->  MaskWithInstructions -> Memory
applyMaskWithInstruction m (maskPair, xs) = updateMemValues m (maskInstructions maskPair xs)

maskInstructions :: MaskPair -> [MemInstruction] -> [MemInstruction]
maskInstructions (om, xm) = concatMap (applyXMask xm) . map (applyOrMask om)

applyOrMask mask (a, v) = (mask .|. a, v)

applyXMask :: String -> MemInstruction -> [MemInstruction]
applyXMask mask (a, v) = map (\x -> (x,v)) $ floatedAddresses addressBits patches
  where xIndices = findIndices (== 'X') mask
        patches :: [Patch]
        patches = map (zip xIndices) $ comb $ length xIndices
        addressBits :: BitList
        addressBits = toBin a
        floatedAddresses :: BitList -> [Patch] -> [Int64]
        floatedAddresses bs ps = map toDec $ map (applyPatch bs) ps

applyPatch :: BitList -> Patch -> BitList
applyPatch bs p = foldl replaceBits bs p

replaceBits :: BitList -> BitPatch -> BitList
replaceBits bs (n,b) = h ++ b:t
  where (h, (_:t)) = splitAt n bs

updateMemValues :: Memory -> [MemInstruction] -> Memory
updateMemValues m xs = foldl updateMemValue m xs
  where updateMemValue ::Memory -> MemInstruction -> Memory
        updateMemValue m (a, v) = M.insert a v m

comb 0 = [[]]
comb n = map (0:) rest ++ map (1:) rest
  where rest = comb (n-1)

toDec :: BitList -> Int64
toDec = foldl1 $ (+) . (*2)

toBin :: Int64 -> BitList
toBin 0 = [0]
toBin n = padding ++ bits
  where bits = reverse (toBin' n)
        padding = replicate (36 - length bits) 0

toBin' 0 = []
toBin' n = let (q,r) = n `divMod` 2 in r : toBin' q
