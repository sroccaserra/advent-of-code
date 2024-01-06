module Day09Spec where

import Day09 hiding (main)

import qualified Data.Vector as V

import Test.Hspec

main = hspec spec

anExample = V.fromList [ 35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182 , 127
                       , 219 , 299, 277, 309, 576 ]
invalidNumber = 127

spec =
  describe "Day 09" $ do
    it "slices a vector" $ do
      previousNs 5 5 anExample `shouldBe` V.fromList [35, 20, 15, 25, 47]
      previousNs 5 14 anExample `shouldBe` V.fromList [95, 102, 117, 150, 182]

    it "finds a matching sum" $ do
      hasMatchingSum 5 anExample 5 `shouldBe` True
      hasMatchingSum 5 anExample 6 `shouldBe` True
      hasMatchingSum 5 anExample 14 `shouldBe` False

    it "finds possible slices" $ do
      possibleSlices anExample 0 `shouldBe` [V.fromList [35]]
      possibleSlices anExample 1 `shouldBe` map V.fromList [[20], [35, 20]]
      possibleSlices anExample 2 `shouldBe` map V.fromList [[15], [20, 15], [35, 20, 15]]

    it "knows if a continuous sum exists" $ do
      findContiguousSum anExample 127 0 `shouldBe` []
      findContiguousSum anExample 127 1 `shouldBe` []
      findContiguousSum anExample 127 5 `shouldBe` [V.fromList [15, 25, 47, 40]]

