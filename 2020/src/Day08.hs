module Day08 where

import Data.Vector hiding ((++), map, length)
import qualified Data.Set as S

main = interact $ show . partTwo . (map parseLine) . lines

parseLine :: String -> Instruction
parseLine = parseInstructions . words
  where parseInstructions (x:y:_) = (readOp x, read $ map clean y)
        parseInstructions ws = error $ "Invalid line: " ++ (unwords ws)
        clean '+' = ' '
        clean c = c
        readOp "acc" = Acc
        readOp "jmp" = Jmp
        readOp "nop" = Nop
        readOp i = error $ "Invalid instruction: " ++ i

partOne xs = exec S.empty $ Machine prg 0 0
  where prg = fromList xs

partTwo xs = findHaltingPrg prg 0 $ Machine prg 0 0
  where prg = fromList xs

type Instruction = (Operation, Int)
data Operation = Jmp | Acc | Nop
               deriving (Eq,Show)

data Machine = Machine (Vector Instruction) Int Int
             deriving (Eq)

instance Show Machine where
    show (Machine prg pc acc) | pc < length prg = show (pc, acc, prg ! pc)
    show (Machine prg pc acc) = "Ended: " ++ show (pc, acc, prg ! (pred pc))

exec :: S.Set Int -> Machine -> Machine
exec s m | isLooping s m = m
exec _ m | hasEnded m = m
exec s m@(Machine prg pc _) = exec (S.insert pc s) $ step m op v
  where (op, v) = prg ! pc

hasEnded (Machine prg pc _) = length prg == pc
isLooping s (Machine _ pc _) = S.member pc s

step :: Machine -> Operation -> Int -> Machine
step (Machine prg pc acc) Acc n = Machine prg (succ pc) $ acc + n
step (Machine prg pc acc) Jmp n = Machine prg (pc + n) acc
step (Machine prg pc acc) Nop _ = Machine prg (succ pc) acc

findHaltingPrg :: Vector Instruction -> Int -> Machine -> Machine
findHaltingPrg _ _ m | hasEnded m = m
findHaltingPrg prg n _ = findHaltingPrg prg (n+1) $ exec S.empty $ mutate (n+1) $ Machine prg 0 0

mutate :: Int -> Machine -> Machine
mutate n (Machine prg pc acc) = Machine prg' pc acc
  where prg' = prg // [(n, switch $ prg ! n)]
        switch (Nop, n) = (Jmp, n)
        switch (Jmp, n) = (Nop, n)
        switch x = x
