module Day23Spec where

import Day23 hiding (main)
import Data.Sequence (Seq(..))
import qualified Data.Sequence as Seq

import Test.Hspec

main = hspec spec

spec =
  describe "Crab game" $ do
    describe "Part one" $ do
      it "matches the example" $ do
        let result = take 10 $ iterate step $ Seq.fromList [3,8,9,1,2,5,4,6,7]
        result `shouldBe` map Seq.fromList [[3,8,9,1,2,5,4,6,7]
                                           ,[2,8,9,1,5,4,6,7,3]
                                           ,[5,4,6,7,8,9,1,3,2]
                                           ,[8,9,1,3,4,6,7,2,5]
                                           ,[4,6,7,9,1,3,2,5,8]
                                           ,[1,3,6,7,9,2,5,8,4]
                                           ,[9,3,6,7,2,5,8,4,1]
                                           ,[2,5,8,3,6,7,4,1,9]
                                           ,[6,7,4,1,5,8,3,9,2]
                                           ,[5,7,4,1,8,3,9,2,6]]

      it "can place removed cups last" $ do
        (step $ Seq.fromList [3,8,9,1,7,5,4,6,2]) `shouldBe` Seq.fromList [7,5,4,6,2,8,9,1,3]

      it "skips removed cups" $ do
        (step $ Seq.fromList [9,8,7,6,1,5,4,3,2]) `shouldBe` Seq.fromList [1,5,8,7,6,4,3,2,9]

      it "wraps around to 9" $ do
        (step $ Seq.fromList [1,9,8,7,6,5,4,3,2]) `shouldBe` Seq.fromList [6,9,8,7,5,4,3,2,1]

      it "has the right 10th step" $ do
        let result = last $ take 11 $ iterate step $ Seq.fromList [3,8,9,1,2,5,4,6,7]
        alignToOne result `shouldBe` Seq.fromList [1,9,2,6,5,8,3,7,4]

    describe "Part two" $ do
      it "can multiply big numbers" $ do
        934001*159792 `shouldBe` 149245887792

      it "removes three cups when i <= len - 3" $ do
        removeThreeAt 1 (s "123456789") `shouldBe` s "156789"
        removeThreeAt 2 (s "123456789") `shouldBe` s "126789"
        removeThreeAt 6 (s "123456789") `shouldBe` s "123456"

      it "removes three cups when i > len - 3" $ do
        removeThreeAt 7 (s "123456789") `shouldBe` s "234567"

      xit "can step with index" $ do
        let firstStep = (0,Seq.fromList [3,8,9,1,2,5,4,6,7])
        stepWithIndex firstStep `shouldBe` (1,Seq.fromList [3,2,8,9,1,5,4,6,7])

s :: String -> Seq Int
s = Seq.fromList . map (read . (:[]))

-- 123456789
-- if i <= len - 3 -- (fst splitAt i) >< (snd splitAt i+3)
-- 1 234 56789
-- 123456 789
-- if > len - 3 -- (snd splitAt (len-i+1) (fst splitAt i))
-- 1 234567 89
-- 12 345678 9
-- 123 3456789
