module Day02Spec where

import Day02 hiding (main)

import Test.Hspec

main = hspec spec

spec =
  describe "Parsing a line" $ do
    it "reads password info" $ do
      let result = parseLine "1-20 a: aaa"
      result `shouldBe` PasswordInfo 1 20 'a' "aaa"

    it "reads passowrd info with parser combinators" $ do
      let result = parseLineReadP "1-20 a: aaa"
      result `shouldBe` PasswordInfo 1 20 'a' "aaa"
