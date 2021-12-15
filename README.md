# aoc2021

## Learnings

See also:

- <https://github.com/sroccaserra/aoc2015#learnings>
- <https://github.com/sroccaserra/aoc2018#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2020#learnings>

### Algorithms

- Breadth-First Search
    - Introduction to Algorithms, Third Edition, 22.2, p. 594
    - Artificial Intelligence, a Modern Approach, 3.4.1, p. 81
    - <https://en.wikipedia.org/wiki/Breadth-first_search>

- Depth-First Search
    - Introduction to Algorithms, Third Edition, 22.3, p. 603
    - Artificial Intelligence, a Modern Approach, 3.4.3, p. 85

- Topological Sort
    - Introduction to Algorithms, Third Edition, 22.4, p. 612
        - Of a DAG, using DFS

- Uniform Cost Search
    - Artificial Intelligence, a Modern Approach, 3.4.2, p. 83
    - <https://en.wikipedia.org/wiki/Dtra%27s_algorithm#Practical_optimizations_and_infinite_graphs>

- Dijkstra's Algorithm
    - Introduction to Algorithms, Third Edition, 24.3, p. 658
    - <https://en.wikipedia.org/wiki/Dtra%27s_algorithm>

- Greedy Best-First Search
    - Artificial Intelligence, a Modern Approach, 3.5.1, p. 92
    - <https://en.wikipedia.org/wiki/Best-first_search>

- A-star Search
    - Artificial Intelligence, a Modern Approach, 3.5.2, p. 93

- Summary
    - Artificial Intelligence, a Modern Approach, 3.7, p. 108

- There is a general presentation of backtracking in the Algorithm Design Manual, in section 7.1 p. 231.
    - Example of usage in Python: <https://leetcode.com/problems/reconstruct-itinerary/discuss/491164/python-backtracking-following-skienas-template>
    - Backtracking ~ <https://en.wikipedia.org/wiki/Backtracking>

### Python

- Python can now pattern match:
    - Structural Pattern Matching: Tutorial ~ <https://www.python.org/dev/peps/pep-0636/>
- Counters can be useful:
    - Counter objects ~ <https://docs.python.org/3/library/collections.html#counter-objects>
- If I mute a matrix m (list of lists) copied with `m.copy()`, there is a good chance that I mute the original matrix also. `[r.copy() for r in m]` should work better. See also `copy.deepcopy()`.

### Haskell

- We can pattern guard on monads with the `<-` operator : `validate xs (y:ys) | Just x <- lookup y brackets = validate (x:xs) ys`
- Beware, if you want to update a count with -n `Map.insertWith (-)` will probably reverse the arguments. Use `flip (-)` or `(+) k (-n)`.

## How it started

```shell
$ stack new aoc2021
$ cd aoc2021
$ rm -r app
$ rm -r test
$ rm -r Changelog.md
```

In package.yaml:
- Remove "executables" section
- Remove "tests" section
- add hspec dependency (LTS) and -W ghc-option in "library" section

```shell
$ stack setup
$ stack build
```

Then write a Spec.hs file in src, and try to run it with:
```shell
$ stack runhaskell -- src/Spec.hs
```

Note: for this simple project, I want all the code in the src directory.
