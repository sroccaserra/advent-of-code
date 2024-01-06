module Day25Spec where

import Day25 hiding (main)

import Test.Hspec

main = hspec spec

-- f subject x = (x*subject) `mod` 20201227
--
-- filter (\x -> snd x == 13768789) $ take 308212 $ zip (iterate succ 0) (iterate (f 11404017) 7)
-- [(308211,13768789)]
-- > factors 308211
-- [3,71,1447]
-- > (11404017*(((7^3 `mod` m)^71 `mod` m)^1447 `mod` m)) `mod` m
-- 3545733
-- > (11404017*(7^308211)) `mod` m
-- 3545733
--
-- 11710225
-- filter ((== 11404017) . snd) $ take 100000000 $ zip
-- (iterate succ 0) (iterate g 1)

spec =
  describe "Day 25" $ do
    it "should find the result by brute force" $ do
      let result = last $ take 308212 $ zip (iterate succ 0) (iterate (f 11404017) 7)
      result `shouldBe` (308211,13768789)

    it "should find the result by brute force" $ do
      let result = filter ((== 11404017) . snd) $ take 11710226 $ zip (iterate succ 0) (iterate (\x -> mod (x*7) 20201227) 1)
      result `shouldBe` [(11710225,11404017)]

----

-- - <https://fr.wikipedia.org/wiki/Congruence_lin%C3%A9aire>
--
-- - <http://villemin.gerard.free.fr/ThNbDemo/ModCongr.htm>

-- Si    a ≡ b (mod m)
-- Alors a-b ≡ 0 (mod m)
--
-- a ≡ b (mod m) ⇔ a (mod m) ≡ b (mod m)

-- Dans une ADDITION ou une MULTIPLICATION (mod m), on peut remplacer un nombre
-- par un autre égal modulo m.

-- On peut additionner ou soustraire ou multiplier par un MÊME NOMBRE de chaque
-- côté d'une égalité mod m.

-- On peut élever à une PUISSANCE de chaque côté d'une égalité mod m (mais pas
-- l'inverse: réciproque fausse).
-- Attention: ne pas travailler en modulo sur les exposants.

-- En général, on ne peut pas DIVISER avec les congruences.

-- a ≡ b (mod m)
-- ou
-- a ≡ b [m]
--
-- a - b ≡ 0 (mod m)
-- a - b = k.m

-- La relation de congruence modulo m est une relation d'équivalence entre les
-- nombres rationnels.
--
-- a ≡ a [m]
-- a ≡ b [m] Alors b ≡ a [m]
--
-- Si a ≡ b [m] et b ≡ c [m]
-- Alors a ≡ c [m]

-- Si : a ≡ b [m] Et c ≡ d [m]
-- Alors :
--
-- a + c ≡ b + d [m]
-- a - c ≡ b - d [m]
--
-- a.c ≡ b.d [m]
--
-- a^k ≡ b^k [m]

----

