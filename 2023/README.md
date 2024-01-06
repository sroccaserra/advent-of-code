Advent of [bad] Code, 2023 edition

- <https://adventofcode.com>

## Learnings

To compute the area of a polygon defined by the closed points sequence {(x<sub>i</sub>, y<sub>i</sub>)}, just take the sum of all the "oriented" trapezoid areas, 1/2\*(y<sub>i</sub>+y<sub>i+1</sub>)\*(x<sub>i</sub>-x<sub>i+1</sub>) (positive in one direction, negative in the other):
- <https://en.wikipedia.org/wiki/Shoelace_formula#Trapezoid_formula_2>

For day 18, we could imagine that the polygon resulting from all the 90 degrees
turns was centered in the cubes. Then, we can add `(d1 ∧ d2)(d2 - d1)/2` to
each point of the polygon to compute an envelope of the right size. d1 and d2
are the normalized directions of the edges that meet at each point. Then, the
above trapezoid formula works out of the box. This idea allows to grow the
"padding" further, by changing the 1/2 factor.

Another approach is Pick's Theorem, that, for a polygon with integer
coordinates for all of its vertices, gives this relation between the area and
the number of integer points in it and on its boundary:

- A = i + b/2 -1
- <https://en.wikipedia.org/wiki/Pick%27s_theorem>

The number of integer coordinates points inside the polygon is i, and the number on the border is b.

Here, we want i + b and we can know A and b, so A + b/2 + 1 gives i + b.

The demonstration of the Pick theorem is interesting, and uses the
triangulation of the polygon into triangles of area 1/2 and containing no
points inside. It also use the Euler formula that gives the relation v - e + f
= 2 for a connected graph, where v e and f are the numbers of vertices, edges
and faces.

- <https://en.wikipedia.org/wiki/Planar_graph#Euler's_formula>

In Haskell, `Data.Sequence` is probably a good enough "random
access" data structure.
