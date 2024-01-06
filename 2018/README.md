## Démarrer un nouveau projet

```
$ stack new aoc2018
$ stack setup
$ stack build
```

## Usage

Those are equivalent:
```
$ stack runhaskell src/01.hs  # Uses corresponding src/XX.txt file by default
$ stack runhaskell src/01.hs src/01.txt  # Allows to choose the input file
$ stack runhaskell src/01.hs - < src/01.txt  # Allows to use stdin
```

## Learnings

See also:

- <https://github.com/sroccaserra/aoc2015#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2020#learnings>
- <https://github.com/sroccaserra/aoc2021#learnings>
- <https://github.com/sroccaserra/aoc2022#learnings>

### Algorithmes

- Summed-area table ~ <https://en.wikipedia.org/wiki/Summed-area_table>
    - A summed-area table is a data structure and algorithm for quickly and
      efficiently generating the sum of values in a rectangular subset of a
      grid.

- When confronted with huge numbers (billions!) of iterations in the secont
  part after a more reasonable first part, look for a stabilisation. For
  example, after 10 times the first part, does the result between two
  iterations become the same? Look for cycles also. If there is a constant
  delta or a cycle, this becomes an easy calculation.

### Smalltalk

- The Collection `#select:`, `#collect:`, ... methods, and in general methods
  that accept a one-argument block also accept a method symbol for argument.
  Simply because the `Symbol` class has a `#value:` method.  Nice.
- `OrderedCollection` makes for a good queue implementation. It has fast
  `#removeFirst` and `#add:` implementations. This is good for Breadth First
  Search like algorithms. Note: this is probably why there is no basic `Queue`
  class in the standard lib? There are a `SharedQueue` and `WaitfreeQueue`
  classes in my image though.
- There is a `Heap` class with `#sortBlock:` and `#removeFirst` methods. This
  is nice for Dijkstra-like algorithms.
- There are `Point`, `G2DCoordinates` and `G3DCoordinates` classes that can be
  used as `Dictionary` keys.
- This makes Smalltalk a pretty good language out of the box for the Advent of
  Code.
- When commiting changes to files in the Git repository (that are probably not
  Smalltalk code) outside the image, the view of the Git repository becomes
  dirty in the image. To fix that, open the Git repository in the image (right
  click and "Open repository"), this shows the commits in the repository, and
  by right-clicking them you can "adopt" them. This should fix the repository
  view in the image.

### Haskell

- On peut construire un graph avec une liste d'arrêtes avec `buildG` ou `graphFromEdges`
- Un `Vertex` est un `Int`, une `Edge` est un `(Int, Int)`, un `Graph` est un
  `Array Int [Int]`. On peut donc manipuler un graph avec les fonctions de
  `Array`.
- Vérifier un fichier sans le compiler : `stack ghc -- -W -fno-code src/Common.hs`
- Utiliser un label dans un pattern matching :
    - `bb@(Coord minX minY, Coord maxX maxY) = boundingBox points`
- Pattern simple vu plusieurs fois : utiliser une fonction `go` dans un `where` pour ammorcer les données initiales d'une fonction récursive (voir la partie 2 du jour 1)
- Combiner `takeWhile` et `scanl` pour appliquer une fonction à une liste d'entrée jusqu'à une condition sur le résultat (voir la deuxième partie du jour 1)
- Utiliser `let` pour affecter le résultat d'un calcul non `IO` dans une `do` notation (voir le `main` du jour 1)
- Générer une liste de liste de coordonnées (par exemple `[[(Int, Int)]]`) :
    - `coordsGrid = map (\y -> (map (flip (,) y) [0..maxX])) [0..maxY]`
    - `coordsGrid = [[(x, y) | x <- [0..maxX]] | y <- [0..maxY]]`
- Voir aussi `range((0, 0), (maxX, maxY))` dans `Data.Ix`
- Appliquer une fonction sur toutes les coordonnées d'une liste de liste :
    - `map f <$> coordsGrid`
    - (appliquer `map f` au Functor `List`, soit `map (map f) coordsGrid`)
