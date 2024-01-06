module Day25 where

main = interact $ show . partOne . (map parseLine) . lines

parseLine = read ::(String -> Integer)

partOne [a,b] = mod (b^x) m
  where [(x,_)] = bruteForce a
partOne _ = error "wrong input"

bruteForce n =
  filter ((== n) . snd) $ take 11710226 $ zip (iterate succ 0) (iterate (\x -> mod (x*7) m) 1)

m = 20201227

---
-- Used for exploration

primes = f [2..]
  where f (p : ns) = p : f [n | n <- ns, n `mod` p /= 0]
        f _ = error "you don't see me"

factors m = f m (head primes) (tail primes) where
  f m n ns
    | m < 2 = []
    | m < n ^ 2 = [m]   -- stop early
    | m `mod` n == 0 = n : f (m `div` n) n ns
    | otherwise = f m (head ns) (tail ns)
