module Globber (matchGlob) where

type GlobPattern = String

matchGlob :: GlobPattern -> String -> Bool

matchGlob ('\\':p:ps) (c:cs) = (p == c) && (matchGlob ps cs)
matchGlob ('*':ps) cs = matchStar ps cs
matchGlob ('?':ps) (_:cs) = matchGlob ps cs
matchGlob ('[':ps) cs = matchBracket ps cs
matchGlob (p:ps) (c:cs) = (p == c) && matchGlob ps cs
matchGlob [] [] = True
matchGlob _ [] = False
matchGlob [] _ = False

matchStar :: GlobPattern -> String -> Bool

matchStar p s@(_:cs) = matchGlob p s || matchStar p cs
matchStar [] [] = True
matchStar _ [] = False

matchBracket :: GlobPattern -> String -> Bool

matchBracket ('\\':']':ps) s@(c:cs) = if c == ']'
	                                  then closeBracket ps cs
	                                  else matchBracket ps s

matchBracket ('\\':p:ps) s@(c:cs) = if p == c
	                                  then closeBracket ps cs
	                                  else matchBracket (p:ps) s

matchBracket ('-':']':ps) (c:cs) = c == '-' && matchGlob ps cs

matchBracket (a:'-':']':ps) s@(c:cs) = if c == a
	                                     then matchGlob ps cs
	                                     else matchBracket ("-]" ++ ps) s

matchBracket (a:'-':'\\':b:ps) s = matchBracket (a:'-':b:ps) s

matchBracket (a:'-':b:ps) s@(c:cs) = if c `elem` [a..b]
	                                   then closeBracket ps cs
	                                   else matchBracket ps s

matchBracket (a:'-':b:ps) [] = if length [a..b] == 0
	                           then closeBracket ps []
	                           else matchBracket ps []

matchBracket ('-':ps) s@(c:cs) = if c == '-'
	                               then closeBracket ps cs
	                               else matchBracket ps s

matchBracket (']':ps) [] = matchGlob ps []

matchBracket (']':_) _ = False

matchBracket (p:ps) s@(c:cs) = if p == c
	                             then closeBracket ps cs
	                             else matchBracket ps s

matchBracket [] _ = error "unterminated character class"
matchBracket _ [] = False

closeBracket :: GlobPattern -> String -> Bool

closeBracket ('\\':']':ps) s = closeBracket ps s
closeBracket (']':ps) s = matchGlob ps s
closeBracket (_:ps) s = closeBracket ps s
closeBracket [] _ = error "unterminated character class"
