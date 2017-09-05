module Ch01.MinfreeSpec (spec) where

import Test.Hspec
import Ch01.Minfree

spec :: Spec
spec = do
  describe "minfree" $ do
    it "本に載っている例" $ do
      minfree [8,23,9,0,12,11,1,10,13,7,41,4,14,21,5,17,3,19,2,6] `shouldBe` 15

  describe "minfree'" $ do
    it "本に載っている例" $ do
      minfree' [8,23,9,0,12,11,1,10,13,7,41,4,14,21,5,17,3,19,2,6] `shouldBe` 15
