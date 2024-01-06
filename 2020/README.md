# aoc2020

Code for the advent of code 2020 event:

- <https://adventofcode.com/2020>

## Setup

How setup was done:

```
$ stack new aoc2020
$ cd aoc2020
$ git init
$ git add .
$ git commit
```

## Running

```
$ echo -e "1: 2,3\n2: 3,4\n3: 5,6" | stack runhaskell -- src/DayXX
[1,2,3]
```

## Tests

Run a single test:

```
$ stack runhaskell -- -isrc test/DayXXSpec
```

Run all tests:

```
$ stack test
```

## Building

```
$ stack ghc -- -O2 -main-is DayXX src/DayXX.hs
```

## Repl

```
$ stack ghci src/DayXX.hs
```

## Learnings

See also:
- <https://github.com/sroccaserra/aoc2015#learnings>
- <https://github.com/sroccaserra/aoc2018#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2021#learnings>
- <https://github.com/sroccaserra/aoc2022#learnings>

### Smalltalk

- `Compiler`'s `#evaluate:` method can evaluate strings

### Python

- `re.match()` checks for a match only at the beginning of the string, while `re.search()` checks for a match anywhere in the string.
- `sys.flags.interactive` can prevent script to execute in REPL: `if __name__ == "__main__" and not sys.flags.interactive:`
- `fileinput` can read lines from `$1` file if any, or from `stdin`: `lines = [l.strip() for l in fileinput.input()]`

### Vim

- Evaluate sub expressions (this evaluates expressions one at a time disregarding priority, or puts everything on one line then evaluate exprs one by one inverting `*` and `+` precedence, see [day 18][d18]):

```
:%s/\d\+ [+*] \d\+\|(\d\+)/\=eval(submatch(0))/
```
or
```
:%s/\(.*\)\n/ + (\1)/
:%s/\d\+ + \d\+\|([^+()]*)\|^[^+]*$/\=eval(submatch(0))/
5000@:
```

- After a new line with wrong indentation, `<Esc>i` or `<CR>` are better that deleting spaces
- To change the last word of a line, `C` works, `de` does not

### Haskell

- Use `zipWith ($)` to apply a list of functions to a list of values
- [until][un] and [takeWhile][tw] can be useful where a `while` loop would be used in other languages
- This function to convert a value to a list looks like it 's eating the value: `(:[]) x` returns `[x]` (useful for point free compositions)
- Use `read :: (String -> Integer)` instead of `Int` or `Int64` when dealing with very very large numbers
- Combine parsers with `<$>` and `<*>`: `readP_to_S ((\x y -> x:y:[]) <$> get <*> get) "abc"` gives `[("ab", "c")]`. Other example:

```haskell
import Control.Applicative
import Text.ParserCombinators.ReadP
import Data.Char

data KeyValue = KeyValue String Int
              deriving (Show)

p :: ReadP KeyValue
p = KeyValue <$> key <* sep <*> value

key = munch1 isAlpha

sep = char ':'

value :: ReadP Int
value = read <$> munch1 isDigit

test = readP_to_S p
```

- `ReadP` parsers can be used with the `Monad` interface with `>>=` or `do`, or with the `Applicative` interface with `<$>`, `<*>`, `<*`, `*>` and `<|>`.
- [chainl][cl] can apply operators while parsing an expression, see <https://github.com/Morendil/AdventOfCode2020/blob/main/Day18.hs>
- `Control.Applicative` can help transpose lists (note that a `transpose` function already exists in `Data.List`):

```haskell
transpose :: [[a]] -> [[a]]
transpose = getZipList . traverse ZipList
```

- Understanding folds by examples: <https://wiki.haskell.org/Foldr_Foldl_Foldl%27>
- `Data.IntMap.Strict` is useful to represent data indexed by `Int`s
- If this program `main = print (foldl (+) 0 [1..1000000])` is compiled in GHC without "-O" flag, it uses a lot of heap and stack (see <https://wiki.haskell.org/Performance/Strictness>)
- Prefer using `foldl` to explicit recursion?
- To poke a batch of zeros and ones in an int, use a string to create an int mask for zeros, an int mask for ones, and apply `.&.` to poke zeros and `.|.` to poke ones (uses some tips below):

```haskell
> zeroMask = foldl1 ((+) . (*2)) $ map (fromEnum . (/='0')) "-----01-1"
> oneMask = foldl1 ((+) . (*2)) $ map (fromEnum . (=='1')) "-----01-1"
> (31 .&. zeroMask) .|. oneMask
23
```

- [sequence][se] can generate combinations:

```haskell
> sequence [['0','1'],['a'],['b'],['0','1']]
["0ab0","0ab1","1ab0","1ab1"]
```

- Reading from `stdin` allows to input lines manually (or paste short examples from the puzzle text) and end by Ctrl+D
- `Data.Complex` is handy for 2D operations (regular addition translates, `(* (0+:1))` rotates 90 °, `(* -(0:+1))` rotates -90 °)
- `Data.Maybe.catMaybes` turns a list of `Maybe a` into a list of `a`
- If I declare both a `main = hspec spec` and a `spec` functions in a test file, I can run them either individually or all.
- For Int indexed values, [Vector][ve] seems more useful than [Array][ar]
- A Text is not a List, like a String is: you can't use Data.List functions on a Text.
- How to print & debug: <https://wiki.haskell.org/Debugging>
- Use [nub][nu] to remove duplicates in a list (no need to sort, but beware n²)
- Use [concat][cc] instead of `foldl1 (++)`
- Instead of `foldl max 0 xs` I can use `foldl1 max xs` and even better, `maximum xs`.
- If I have a list of `0`s and `1`s, I can convert them to decimal numbers with `foldl1' $ (+) . (*2)`
- With [span][sp] or [break][br] I can split a list with a predicate (see also [takeWhile][tw] and [dropWhile][dw])
- With [lookup][lu] I can lookup in a dumb association structure (`a -> [(a, b)] -> Maybe b`), not unlike Lisp's [association lists][al]
- With [mapM_][mm] I can apply print to a list of results:

```haskell
main = do
  xs <- fmap lines getContents
  mapM_ print $ map parseLine xs
```

- The [interact][in] function passes the input from stdin to a `String -> String` function and prints the result to stdout
- The [cycle][cy] function turns a finite list to a cycling infinite one
- The [mapMaybe][ma] function (`(a -> Maybe b) -> [a] -> [b]`)
- The [fromEnum][fe] function, used to convert `Bool` to `Int` in day 03
- The [fromMaybe][fm] function (`a -> Maybe a -> a`)
- The [ReadP][rp] module & how it works (see refs about parser combinators below)
- The [Regex.TDFA][re] module to use regexes in Haskell (see commit [f38935c][rrc])
- The [&][&] operator, works like a pipe operator
- The `do` notation can be used as a [list comprehension][lc]

[&]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Function.html#v:-38-
[al]: https://www.gnu.org/software/emacs/manual/html_node/elisp/Association-Lists.html
[ar]: https://hackage.haskell.org/package/array
[br]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:break
[cc]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:concat
[cl]: https://hackage.haskell.org/package/base-4.14.1.0/docs/Text-ParserCombinators-ReadP.html#v:chainl
[cy]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:cycle
[d18]: https://adventofcode.com/2020/day/18
[dw]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:dropWhile
[fe]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:fromEnum
[fm]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Maybe.html#v:fromMaybe
[in]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:interact
[lc]: https://wiki.haskell.org/List_comprehension
[lu]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:lookup
[ma]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Maybe.html#v:mapMaybe
[mm]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:mapM_
[nu]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Data-List.html#v:nub
[re]: https://hackage.haskell.org/package/regex-tdfa-1.3.1.0/docs/Text-Regex-TDFA.html
[rp]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Text-ParserCombinators-ReadP.html
[rrc]: https://github.com/sroccaserra/aoc2020/commit/f38935c
[se]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:sequence
[sp]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:span
[tw]: https://hackage.haskell.org/package/base-4.14.0.0/docs/Prelude.html#v:takeWhile
[un]: https://hackage.haskell.org/package/base-4.14.1.0/docs/Prelude.html#v:until
[ve]: https://hackage.haskell.org/package/vector-0.12.1.2

### Algorithms & Data structures

- The [discrete logarithm][dl] _log<sub>b</sub> a_ is the integer _x_ such that _a<sup>x</sup> = b_

> Discrete logarithms are quickly computable in a few special cases. However, no efficient method is known for computing them in general. Several important algorithms in public-key cryptography base their security on the assumption that the discrete logarithm problem over carefully chosen groups has no efficient solution.

- Given a cyclic group of order _n_, a generator _a_ of the group and a group element _b_, the [baby-step giant-step][bg] helps find an integer _x_ such that _a<sup>x</sup> = b_, or _a<sup>x</sup> ≡ b [n]_ (useful for day 25 -- I didn't use it, I learned about it too late)
- To represent a finite chained list of ints of constant size, we can use a fixed size array with each index pointing to its next value (see [day 23](src/day_23.py) ).
    - `cycle 1:0:2:[]` can be encoded: a[1] = 0, a[0] = 2, a[2] = 1 (this would make the chained list cyclic)
    - moving around a sublist is O(1), finding the next element of any int is O(1)
- See [day 13 (Haskell)](src/Day13.hs) and [day 13 (Python)](src/Day13PartTwo.py) for examples of use of:
    - the [Chinese remainder Theorem][cr]
    - the [extended Euclidean algorithm][egcd]
    - [Bézout's identity][bi]
    - [Fermat's little theorem][flt]
    - the [modular multiplicative inverse][mmi]

- _a<sup>n-1</sup> ≡ 1 [n]_ => _a*a<sup>n-2</sup> ≡ 1 [n]_ (easy modular inverse with Fermat's little theorem)

- <https://fr.wikipedia.org/wiki/Congruence_lin%C3%A9aire>
- <http://villemin.gerard.free.fr/ThNbDemo/ModCongr.htm>

[bg]: https://en.wikipedia.org/wiki/Baby-step_giant-step
[cr]: https://en.wikipedia.org/wiki/Chinese_remainder_theorem
[dl]: https://en.wikipedia.org/wiki/Discrete_logarithm
[egcd]: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
[mmi]: https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
[flt]: https://en.wikipedia.org/wiki/Fermat%27s_little_theorem
[bi]: https://en.wikipedia.org/wiki/B%C3%A9zout%27s_identity

## References

- <https://two-wrongs.com/parser-combinators-parsing-for-haskell-beginners>
- <https://github.com/Morendil/AdventOfCode2019>
- <https://ravichugh.gitbooks.io/a-quarter-of-haskell/content/parsing/more.html>
- <https://haskell-containers.readthedocs.io/en/latest/sequence.html>
- <https://www.redblobgames.com/grids/hexagons/>
