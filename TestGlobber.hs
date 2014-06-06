module Main (main) where

import Test.Hspec

import Globber
import TestLab1

main :: IO ()
main = hspec $ describe "Testing Globber" $ do

    describe "empty cases" $ do
      it "matches empty string" $
        matchGlob "" "" `shouldBe` True
      it "shouldn't match non-empty string" $
        matchGlob "" "string" `shouldBe` False

    describe "question mark cases" $ do
      it "matches any single character" $
      	matchGlob "?" "*" `shouldBe` True
      it "matches any single character" $
      	matchGlob "?" "?" `shouldBe` True
      it "shouldn't matches empty string" $
      	matchGlob "?" "" `shouldBe` False

    describe "asterisk cases" $ do
      it "should match empty string" $
      	matchGlob "*" "" `shouldBe` True
      it "should match long string" $
      	matchGlob "*" ['-'..'z'] `shouldBe` True
      it "should match sandwiched asterisk" $
        matchGlob "*[a-z]*" "random" `shouldBe` True
      it "should match sandwiched asterisk" $
        matchGlob "*[-]*" "random" `shouldBe` False
      it "should match sandwiched asterisk" $
        matchGlob "[-]*[a-z]" "-random" `shouldBe` True

    describe "escape cases" $ do
      it "should match escape" $
        matchGlob "\\\ab" "\ab" `shouldBe` True
      it "should match escape" $
      	matchGlob "[a\\-b]" "-" `shouldBe` True
      it "should match escape" $
      	matchGlob "[\\a-\\c]" "b" `shouldBe` True
      it "should match range" $
        matchGlob "[a-b-z]" "-" `shouldBe` True
      it "should match range" $
        matchGlob "[a-bx-z]" "h" `shouldBe` False
      it "should match range" $
        matchGlob "[a-b-z]" "h" `shouldBe` False
      it "should match range" $
        matchGlob "[a-dx-z]" "y" `shouldBe` True
      it "should match range" $
        matchGlob "[a-dx-z]" "c" `shouldBe` True
      it "should match empty" $
      	matchGlob "[]" "" `shouldBe` True
      it "should match empty" $
      	matchGlob "[z-a]" "" `shouldBe` True
      it "should match escape" $
      	matchGlob "A\\*" "A*" `shouldBe` True
      it "should match escape" $
      	matchGlob "ab\\*ba" "ab*ba" `shouldBe` True
      it "should match escape" $
      	matchGlob "ab\\*ba" "abba" `shouldBe` False
      it "should match escape" $
        matchGlob "ab\\[ba" "ab[ba" `shouldBe` True
      it "should match escape" $
        matchGlob "ab[a\\[]ba" "ab[ba" `shouldBe` True
      it "should match escape" $
        matchGlob "ab[a\\[]ba" "ababa" `shouldBe` True
      it "should match escape" $
        matchGlob "[a[b]" "a" `shouldBe` True
      it "should match escape" $
        matchGlob "[a[b]" "[" `shouldBe` True
      it "should match escape" $
        matchGlob "[a[b]" "b" `shouldBe` True
      it "should match escape" $
      	matchGlob "[a[b]" "]" `shouldBe` False
      it "should match escape" $
        matchGlob "ab[a\\]]ba" "ab]ba" `shouldBe` True
      it "should match escape" $
        matchGlob "ab[a\\]]ba" "ababa" `shouldBe` True

    describe "literal cases" $ do 
      it "should match - literal" $
        matchGlob "[--]" "-" `shouldBe` True
      it "should match - literal" $
        matchGlob "[--]" "--" `shouldBe` False
      it "should match - literal" $
        matchGlob "[---]" "-" `shouldBe` True
      it "should match - literal" $
        matchGlob "[---]" "--" `shouldBe` False
      it "should match - literal" $
        matchGlob "[----]" "-" `shouldBe` True
      it "should match - literal" $
        matchGlob "[----]" "--" `shouldBe` False
      it "should match literal combinations" $
        matchGlob "[a-h--]" "-" `shouldBe` True
      it "should match literal combinations" $
        matchGlob "[a-h--]" "c" `shouldBe` True
      it "should match literal combinations" $
        matchGlob "[a-h--]" "z" `shouldBe` False


    describe "range cases" $ do
      it "should match tricky range" $
        matchGlob "[a[b-d]e]" "ae]" `shouldBe` True
      it "should match tricky range" $
        matchGlob "[a[b-d]e]" "[e]" `shouldBe` True
      it "should match tricky range" $
        matchGlob "[a[b-d]e]" "be]" `shouldBe` True
      it "should match tricky range" $
        matchGlob "[a[b-d]e]" "ce]" `shouldBe` True
      it "should match tricky range" $
        matchGlob "[a[b-d]e]" "de]" `shouldBe` True
      it "should match tricky range" $
        matchGlob "[a[b-d]e]" "abe" `shouldBe` False
      it "should match concatenated range" $
        matchGlob "*[a\\]x-z-]" "randomrandoma" `shouldBe` True
      it "should match concatenated range" $
        matchGlob "*[a\\]x-z-]" "randomrandom]" `shouldBe` True
      it "should match concatenated range" $
        matchGlob "*[a\\]x-z-]" "randomrandom-" `shouldBe` True
      it "should match concatenated range" $
        matchGlob "*[a\\]x-z-]" "randomrandomy" `shouldBe` True
      it "should match concatenated range" $
        matchGlob "*[a\\]x-z-][]" "randomrandom-" `shouldBe` True
      it "should match concatenated range" $
        matchGlob "*[a\\]x-z-][a-z]" "randomrandom-z" `shouldBe` True
      it "should match crazy range" $
        matchGlob "[a-b--z]" "@" `shouldBe` True
      it "should match crazy range" $
        matchGlob "[a-b--z]" "^" `shouldBe` True
      it "should match crazy range" $
        matchGlob "[a-b--z]" "]" `shouldBe` True
      it "should match crazy range" $
        matchGlob "*[a-d]*" "R" `shouldBe` False
      it "should match crazy range" $
        matchGlob "*[a-d]*" "eeeee" `shouldBe` False

    testLab1


