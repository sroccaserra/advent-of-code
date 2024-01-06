## Learnings

See also:
- <https://github.com/sroccaserra/aoc2018#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2020#learnings>
- <https://github.com/sroccaserra/aoc2021#learnings>
- <https://github.com/sroccaserra/aoc2022#learnings>

### Python

- Use `defaultdict(int)` to count elements:
    - d = defaultdict(int) # then d[k] += 1, values default to zero
    - beware, in a defaultdict even a read can invalidate iterators
    - `defaultdict(bool)` might be useful too, but a `set()` might be better
- There are useful implementations in Python's itertools doc: <https://docs.python.org/3/library/itertools.html> (see "Itertools Recipes" section)

### Maths & Algorithms

- The sum of a number's divisors is equal to the product of (1 + p + p^2 + ... + p^k) where p is a prime divisor and k is its exponent in n's factorisation. S(144) = S(2^4.3^2) = S(2^4).S(3^2) Also, 1 + p + p^2 + . . . + p^k = (p^(k+1) - 1) / (p-1) - <https://www2.math.upenn.edu/~deturck/m170/wk3/lecture/sumdiv.html>
- <https://en.wikipedia.org/wiki/Knapsack_problem>
- <https://en.wikipedia.org/wiki/Stars_and_bars_%28combinatorics%29>

- If I make a map of values to list of values (or a dict or hashtable of values
  to arrays of values, same idea), I am probably working with a tree or graph
  like structure. There are probably classic algorithms I can use to solve the
  problem, and classical structures I can use to represent it (I can switch to
  adjacenty list or matrix if it works better for example).

### Haskell
- `concatMap f . g` is `g >=> f` (see [day 10](src/10.hs))
