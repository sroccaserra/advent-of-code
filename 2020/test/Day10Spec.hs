module Day10Spec where

import Day10 hiding (main)

import Test.Hspec

import Data.List

main = hspec spec

exampleShort = [16 ,10 ,15 ,5 ,1 ,11 ,7 ,19 ,6 ,12 ,4]

exampleLonger = [ 28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39, 11, 1
                , 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3 ]

spec =
  describe "Day 10" $ do
    it "sorts short example" $ do
      sort exampleShort `shouldBe` [1,4,5,6,7,10,11,12,15,16,19]

    it "sorts longer example" $ do
      take 10 (sort exampleLonger) `shouldBe` [1,2,3,4,7,8,9,10,11,14]

    it "computes differences of short example" $ do
      computeDifferences exampleShort `shouldBe` [3,1,1,1,3,1,1,3,1,3]

    it "computeDifferences of longer example" $ do
      computeDifferences exampleLonger `shouldBe`
        [1,1,1,3,1,1,1,1,3,3,1,1,1,3,1,1,3,3,1,1,1,1,3,1,3,3,1,1,1,1]

    it "checks length" $ do
      length exampleShort `shouldBe` 11
      length (computeDifferences exampleShort) `shouldBe` 10

      length exampleLonger `shouldBe` 31
      length (computeDifferences exampleLonger) `shouldBe` 30

    it "finds 35 for part one with short example" $ do
      partOne exampleShort `shouldBe` 35

    it "has two possibilities for two 1s surrounded by 3s" $ do
      computeDifferences [1,4,5,6,9] `shouldBe` [3,1,1,3]
      computeDifferences [1,4,6,9] `shouldBe` [3,2,3]

    it "has four possibilities for three 1s surrounded by 3s" $ do
      computeDifferences [1,4,5,6,7,10] `shouldBe` [3,1,1,1,3]
      computeDifferences [1,4,5,7,10] `shouldBe` [3,1,2,3]
      computeDifferences [1,4,6,7,10] `shouldBe` [3,2,1,3]
      computeDifferences [1,4,7,10] `shouldBe` [3,3,3]

    it "has seven possibilities for four 1s surrounded by 3s" $ do
      computeDifferences [1,4,5,6,7,8,11] `shouldBe` [3,1,1,1,1,3]
      computeDifferences [1,4,5,6,8,11] `shouldBe` [3,1,1,2,3]
      computeDifferences [1,4,5,7,8,11] `shouldBe` [3,1,2,1,3]
      computeDifferences [1,4,6,7,8,11] `shouldBe` [3,2,1,1,3]
      computeDifferences [1,4,6,8,11] `shouldBe` [3,2,2,3]
      computeDifferences [1,4,5,8,11] `shouldBe` [3,1,3,3]
      computeDifferences [1,4,7,8,11] `shouldBe` [3,3,1,3]
