module Day09Spec where

import Day09 hiding (main)

import qualified Data.Vector as V

import Test.Hspec

main = hspec spec

firstExample = V.fromList [ 35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182
                          , 127, 219 , 299, 277, 309, 576 ]
spec =
  describe "Day 09" $ do
    it "slices a vector" $ do
      previousNs 5 5 firstExample `shouldBe` V.fromList [35, 20, 15, 25, 47]
      previousNs 5 14 firstExample `shouldBe` V.fromList [95, 102, 117, 150, 182]

    it "finds a matching sum" $ do
      hasMatchingSum 5 firstExample 5 `shouldBe` True
      hasMatchingSum 5 firstExample 6 `shouldBe` True
      hasMatchingSum 5 firstExample 14 `shouldBe` False

