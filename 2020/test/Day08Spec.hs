module Day08Spec where

import Day08 hiding (main)

import Data.Vector
import qualified Data.Set as S
import Test.Hspec

main = hspec spec

spec =
  describe "Programm execution" $ do
    it "Adds 5" $ do
      let prg = fromList [(Acc, 5)]
      let m = Machine prg 0 0

      exec S.empty m `shouldBe` Machine prg 1 5
