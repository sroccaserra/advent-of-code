module Day24Spec where

import Day24 hiding (main)
import qualified Data.Map as Map

import Test.Hspec

main = hspec spec

m = Map.fromList

spec =
  describe "Day 24" $ do
    it "follows a path" $ do
      let path1 = parseLine "nwwswee"
      followPath (0,0,0) path1 `shouldBe` (0,0,0)

      let path2 = parseLine "esew"
      followPath (0,0,0) path2 `shouldBe` (0,-1,1)

    it "builds initial grid" $ do
      initialGrid [[E]] `shouldBe` m [((1,-1,0),Black)]
      initialGrid [[SE]] `shouldBe` m [((0,-1,1),Black)]
      initialGrid [[SW]] `shouldBe` m [((-1,0,1),Black)]
      initialGrid [[W]] `shouldBe` m [((-1,1,0),Black)]
      initialGrid [[NW]] `shouldBe` m [((0,1,-1),Black)]
      initialGrid [[NE]] `shouldBe` m [((1,0,-1),Black)]

      initialGrid [[E,E]] `shouldBe` m [((2,-2,0),Black)]

    it "finds neighbors" $ do
      neighbors (0,0,0) `shouldBe` [(1,-1,0),(0,-1,1),(-1,0,1),(-1,1,0),(0,1,-1),(1,0,-1)]

    it "evolves tiles" $ do
      evolve Black 0 `shouldBe` White
      evolve Black 1 `shouldBe` Black
      evolve Black 2 `shouldBe` Black
      evolve Black 3 `shouldBe` White
      evolve Black 4 `shouldBe` White

      evolve White 0 `shouldBe` White
      evolve White 1 `shouldBe` White
      evolve White 2 `shouldBe` Black
      evolve White 3 `shouldBe` White

    it "steps grid" $ do
      step (m [((0,0,0),Black)]) `shouldBe` Map.empty
      step (m [((0,0,0),Black),((1,-1,0),Black)]) `shouldBe` m [((0,-1,1),Black),((0,0,0),Black),((1,-1,0),Black),((1,0,-1),Black)]
