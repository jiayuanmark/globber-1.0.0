module TestLab1 (testLab1) where

import Test.Hspec
import qualified Test.Hspec.Core as Hspec

import Globber

type TestCase = (String, String)

positive :: [TestCase]
positive =
  -- straight matches
  [ ("12345abcde", "12345abcde")
  , ("", "")
  , ("a", "a")
  , ("A", "A")
  , ("-", "-")
  , ("]", "]")
  , ("*", "")
  , ("?", "a")
  , ("?", "?")
  , ("?", ".")
  , (".", ".")
  , ("_]", "_]")
  , ("_]]", "_]]")
  , ("()_]]", "()_]]")
  -- escpaes
  , ("\\a", "a")
  , ("\\\\", "\\")
  , ("\\[", "[")
  , ("\\?", "?")
  , ("\\*", "*")
  , ("a]b", "a]b")
  , ("\\a\\b\\c\\d\\e", "abcde")
  , ("-ab\\-", "-ab-")
  , ("\\[a]", "[a]")
  -- test question
  , ("a?b", "aab")
  , ("a?b", "a.b")
  , ("a?b", "a\\b")
  , ("???", "abc")
  , ("???", "ABC")
  , ("hell?", "hello")
  , ("hell?", "hellw")
  -- test star
  , ("a*", "a")
  , ("a*", "aaaaaaaaaa")
  , ("ab*", "abadafads12312312")
  , ("*.hs", "a.hs")
  , ("*.hs", "b.hs")
  , ("*.hs", "*.hs")
  , ("*.hs", ".hs")
  , ("1*2", "12")
  , ("1*2", "1.2")
  , ("1*2", "1__2")
  , ("1*2", "111222")
  , ("a*a*a*", "aaa")
  , ("a*a*a*", "a1_fdfds9*a7123_ateioqerq")
  -- test set match
  , ("[ab]", "a")
  , ("[ab]", "b")
  , ("[ab]g", "bg")
  , ("[ab[c]", "a")
  , ("[ab[c]", "b")
  , ("[ab[c]", "c")
  , ("[ab[c]", "[")
  , ("[ab[c]", "[")
  , ("[a-z]", "a")
  , ("[a-z]", "z")
  , ("[a-z]", "g")
  , ("[a-z]", "h")
  , ("[---]", "-")
  , ("-[---]]", "--]")
  , ("[a-a]", "a")
  , ("[a\\-z]", "-")
  , ("[a\\-z]", "z")
  , ("[a\\-z]", "a")
  , ("[az-a]", "a")
  , ("[\\[]", "[")
  , ("*[a-d]*", "c")
  , ("*[a-d]*", "__ac__981")
  , ("*[a-d]*", "__ad__981")
  , ("[a-c-e]", "a")
  , ("[a-c-e]", "b")
  , ("[a-c-e]", "c")
  , ("[a-c-e]", "-")
  , ("[a-c-e]", "e")
  , ("[a-cc-e]", "e")
  , ("[a-cc-e]", "c")
  , ("[a-cc-e]", "b")
  , ("[----]", "-")
  , ("[a-z-]", "-")
  ]

negative :: [TestCase]
negative = 
  -- test literal matches
  [ ("a", "")
  , ("a", "A")
  , ("a", "b")
  , ("aa", "ab")
  , ("_]", "+b")
  -- test question
  , ("?", "")
  , ("a?", "a")
  , ("??", "a")
  , ("??_", "azz")
  , ("hell?", "hell")
  , ("hell?", "hell00")
  -- test escaping
  , ("\\?", ".")
  , ("\\*", ".")
  , ("\\\\", ".")
  , ("\\[a]", "a")
  , ("\\a\\b\\c", "\\a\\b\\c")
  -- test star
  , ("a*a", "abc")
  , ("a*", "AA")
  , ("a*", "1aaaaaaaaaa")
  , ("ab*", "Hbadafads12312312")
  , ("*.hs", "a.s")
  , ("*.hs", "bhs")
  , ("*.hs", "*")
  , ("a*a*a*", "aeeeeaeeee")
  , ("a*a*a*", "a1_fdfds9*A7123_ateioqerq")
  -- test set match
  , ("[ab]", "c")
  , ("[ab]", "[ab]")
  , ("[ab]", "ab")
  , ("[ab]", "B")
  , ("[ab]", "")
  , ("[ab]g", "0g")
  , ("[ab[c]", "Z")
  , ("[ab[c]", "9")
  , ("[ab[c]", "d")
  , ("[ab[c]", "]")
  , ("[a-z]", "A")
  , ("[a-z]", "aa")
  , ("[---]", "a")
  , ("-[---]]", "a")
  , ("[a-a]", "b")
  , ("[a-a]", "-")
  , ("[a\\-z]", "b")
  , ("[a\\-z]", "d")
  , ("[a\\-z]", "\\")
  , ("[az-a]", "b")
  , ("[az-a]", "z")
  , ("[az-b]", "b")
  , ("[az-b]", "-")
  , ("*[a-d]*", "R")
  , ("*[a-d]*", "eeeee")
  , ("[a-c-e]", "d")
  , ("[a-cc-e]", "f")
  , ("[----]", "b")
  , ("[a-z-]", "A")
  ]

testLab1 ::Spec
testLab1 = do
  describe "glob matching" $ do
    describe "expected matches" $
      Hspec.fromSpecList $ map mkTest $ zip [1..] positive

    describe "expected misses" $
      Hspec.fromSpecList $ map mkNTest $ zip [1..] negative
  
mkTest :: (Int, (String, String)) -> Hspec.SpecTree
mkTest (i, (glb, str)) = Hspec.it (show i) (matchGlob glb str)

mkNTest :: (Int, (String, String)) -> Hspec.SpecTree
mkNTest (i, (glb, str)) = Hspec.it (show i) (not $ matchGlob glb str)

