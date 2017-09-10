module SomeSpec (spec) where

import Test.Hspec

spec :: Spec
spec = do
  describe "SomeSpec" $ do
    it "hoge" $ do
  	1 `shouldBe` 1