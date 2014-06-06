# Stanford CS240h Lab 1

You will write a simple function that performs [glob
matching](http://en.wikipedia.org/wiki/Glob_%28programming%29) Glob
matching is a simple form of pattern matching (i.e., regular
expressions but greatly reduced).

The function should have the type: 

        type GlobPattern = String

        matchGlob :: GlobPattern -> String -> Bool

Where the first argument will be the glob pattern and the second
argument will be the string to match on. The function should return
`True` if the string matches the glob.

We are providing a skeleton Cabal project to help get started,
download it from
[here](http://www.scs.stanford.edu/14sp-cs240h/labs/lab1.tar.gz).

## Due Date

Lab 1 should be submitted by the start of class (12:50pm) on *Tuesday,
April 7th*.

## Glob Matching

Your glob matcher should handle any combination of the following
patterns:

* `"?"` -- matches any single character
* `"*"` -- matches any string including empty.
* `"[abc]"` -- matches a single character that is either 'a', 'b' or
  'c'
* `"[a-z]"` -- matches any single character in the range of 'a' to
  'z'.

And of course, literal characters!

Please be aware of the following details of the `"[]"` matcher:

* `"[-abc]"` -- matches a single character that is either '-', 'a',
  'b', or 'c'. That is, '-' in the first or last position of `"[]"`
  behaves as a literal '-' and not a range specifier.
* `"[abc-]"` -- same as above.

For range matches, please use the following rules for parsing:

* No nesting of range matches.
* A `-` character in the first or last position should be treated as a
  literal `-`.
* Parsing from left-to-right, a group of 3 (`abc`) characters where
  `-` is the middle one (`b`) is considered a range group from `a` to
  `c`.  This range may be empty. The Haskell `Char` `Ord` instance
  should be used for the range.
* A `-` character directly after a range group should be treated as a
  literal `-`.
* A range match can contain more than one range group.

So for example:

* `"[--]"` -- matches a literal `-` character.
* `"[---]"` -- is a range but of only one character, `-`.
* `"[----]"` -- is a range (of just `-`) and a literal `-`, so it just
  matches a `-` character.
* `"[a-d-z]"` -- matches `a`, `b`, `c`, `d`, `-`, `z`.
* `"[]"` -- empty, matches nothing.
* `"[z-a]"` -- empty range, mathces nothing.

Glob pattern speficifiers can also be escaped by prefixing them with
'\'. So the patterm `"A\*"` only matches the string `"A*"`. Some
escape examples:

* `"ab\*ba"` matches `"ab*ba"`
* `"ab\[ba"` matches `"ab[ba"`
* `"ab[a\]]ba"` matches `"ab]ba"` or `"ababa"`

## Cabal -- Build & Test Tool

Cabal is the standard build and packaging tool for Haskell. A starting
framework is provided for you. You can find the user guide for Cabal
[here](http://www.haskell.org/cabal/users-guide/developing-packages.html#test-suites).

## Provided Files

The files provided to get started are:

* globber.cabal -- specifies the build system.
* Globber.hs -- you should edit this file to implement a glob matcher
* TestGlobber.hs -- the test harness. You need to edit this and add
  your own tests!

## Building Lab 1

To get up and running (using Cabal), issue the following commands:

        cabal sandbox init

This will initiate a self-contained build environment where any
dependencies you need are installed locally in the current directory.
This helps avoid the Haskell equivalent of 'DLL Hell!'. If your
version of cabal is older such that it doesn't have the `sandbox`
command, then just proceed without it and it should all be fine.

Next, you want to build the lab. For that, issue the following
commands:

        cabal install --only-dependencies --enable-tests
        cabal configure --enable-tests
        cabal build

After that, you should also be able to run the test harness simply by
typing:

        cabal test

And you'll get some pretty output!

## Testing Lab 1

Some skeleton code for a test framework is provided in
`TestHarness.hs`. You'll need to edit it to add your own tests. The
test framework uses a Haskell package called
[hspec](http://hspec.github.io/). Please refer to it for documentation
on how to use it.

## Grading

While we strongly encourage you to take testing seriously and write a
comprehensive test suite, we are only going to grade you on your glob
matching implementation.

## Submitting

First, simply type:

        cabal sdist

This will generate a tar file of your code in `dist/globber.tar.gz`.

Then go to [upload.ghc.io](http://upload.ghc.io/) and submit your work
through the online form.

If you have any trouble submitting on-line, then please email the
staff mailing [list](mailto:cs240h-staff@scs.stanford.edu).

