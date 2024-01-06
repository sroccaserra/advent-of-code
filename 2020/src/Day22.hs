module Day22 where

import qualified Data.Set as S

main = print partTwo

player1Deck = [28,3,35,27,19,40,14,15,17,22,45,47,26,13,32,38,43,24,29,5,31,48,49,41,25]
player2Deck = [34,12,2,50,16,1,44,11,36,6,10,42,20,8,46,9,37,4,7,18,23,39,30,33,21]

player1DeckEx = [9,2,6,3,1]
player2DeckEx = [5,8,4,7,10]

player1DeckLooping = [43,19]
player2DeckLooping = [2,29,14]

partOne = score finalRound
  where finalRound = combat player1Deck player2Deck

partTwo = score finalRound
  where finalRound = combatRec S.empty player1Deck player2Deck
--   where finalRound = combatRec S.empty player1DeckEx player2DeckEx
--   where finalRound = combatRec S.empty player1DeckLooping player2DeckLooping

score deck = sum $ zipWith (*) (reverse [1..length deck]) deck

combat [] p2d = p2d
combat p1d [] = p1d
combat (x:p1d) (y:p2d) | x > y = combat (p1d++[x,y]) p2d
combat (x:p1d) (y:p2d) = combat p1d (p2d++[y,x])

combatRec _ [] p2d = p2d
combatRec _ p1d [] = p1d
combatRec s p1d p2d | S.member (p1d,p2d) s = p1d
combatRec s (x:p1d) (y:p2d) | isSubgame (x:p1d) (y:p2d) =
  combatRec s' (p1d++xs) (p2d++ys)
  where (xs,ys) = subgame S.empty (x,y) subDeck1 subDeck2
        s' = S.insert ((x:p1d), (y:p2d)) s
        subDeck1 = take x p1d
        subDeck2 = take y p2d
combatRec s (x:p1d) (y:p2d) | x > y = combatRec s' (p1d++[x,y]) p2d
  where s' = S.insert ((x:p1d), (y:p2d)) s
combatRec s (x:p1d) (y:p2d) = combatRec s' p1d (p2d++[y,x])
  where s' = S.insert ((x:p1d), (y:p2d)) s

isSubgame (x:p1d) (y:p2d) = x <= (length p1d) && y <= (length p2d)
isSubgame _ _ = error "wrong subgame"

subgame :: S.Set ([Int],[Int]) -> (Int,Int) -> [Int] -> [Int] -> ([Int],[Int])
subgame _ (x,y) [] _ = ([],[y,x])
subgame _ (x,y) _ [] = ([x,y],[])
subgame s (x,y) p1d p2d | S.member (p1d,p2d) s = ([x,y],[])

subgame s (x,y) (a:p1d) (b:p2d) | isSubgame (a:p1d) (b:p2d) =
  subgame s' (x,y) (p1d++xs) (p2d++ys)
  where (xs,ys) = subgame S.empty (a,b) subDeck1 subDeck2
        s' = S.insert ((a:p1d),(b:p2d)) s
        subDeck1 = take a p1d
        subDeck2 = take b p2d

subgame s (x,y) (a:p1d) (b:p2d) | a > b = subgame s' (x,y) (p1d++[a,b]) p2d
  where s' = S.insert ((a:p1d),(b:p2d)) s

subgame s (x,y) (a:p1d) (b:p2d) = subgame s' (x,y) p1d (p2d++[b,a])
  where s' = S.insert ((a:p1d),(b:p2d)) s
