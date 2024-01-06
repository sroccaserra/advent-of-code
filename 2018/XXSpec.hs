import XX hiding (main)

import Test.Hspec

main = hspec spec

spec =
  describe "placeholder" $ do
    it "shows how to test" $ do
      let result = partOne "hello world"
      result `shouldBe` "hello world"
