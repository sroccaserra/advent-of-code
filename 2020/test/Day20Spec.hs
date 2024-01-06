module Day20Spec where

import Day20 hiding (main)

import Test.Hspec

main = hspec spec

tile_small_s =
  " Tile 1: \n\
  \ #.. \n\
  \ ##. \n\
  \ .#. \n"

seaExample = ["                      "
             ,"                    # "
             ,"  #    ##    ##    ###"
             ,"   #  #  #  #  #  #   "
             ,"                    # "
             ,"  #    ##    ##    ###"
             ,"   #  #  #  #  #  #   "]


spec =
  describe "Day 20" $ do
    it "flips a tile" $ do
      let [t] = parseTiles tile_small_s
      let (Tile _ xs) = flipTile t
      xs `shouldBe` ["..#",".##",".#."]
    it "turns a pattern into a coords list" $ do
      let motif = ["###","#  "]
      coordsFromMotif motif `shouldBe` [(2,0),(1,0),(0,0),(0,1)]
      coordsFromMotif seaMonster `shouldBe` [(18,0)
                                            ,(19,1),(18,1),(17,1),(12,1),(11,1),(6,1),(5,1),(0,1)
                                            ,(16,2),(13,2),(10,2),(7,2),(4,2),(1,2)]
    it "finds a sea monster in itself" $ do
      hasSeaMonster seaMonster (0,0) `shouldBe` True

    it "finds a sea monster in the sea" $ do
      hasSeaMonster seaExample (0,0) `shouldBe` False
      hasSeaMonster seaExample (0,2) `shouldBe` False
      hasSeaMonster seaExample (2,1) `shouldBe` True

    it "counts a sea monster in the sea" $ do
      countSeaMonsters seaMonster `shouldBe` 1
      countSeaMonsters seaExample `shouldBe` 2
