- <http://adventofcode.com/2022>

See also:

- <https://github.com/sroccaserra/aoc2015#learnings>
- <https://github.com/sroccaserra/aoc2018#learnings>
- <https://github.com/sroccaserra/aoc2019#learnings>
- <https://github.com/sroccaserra/aoc2020#learnings>
- <https://github.com/sroccaserra/aoc2021#learnings>

## Learnings

- Floyd–Warshall algorithm: algorithm for finding shortest paths in a directed
  weighted graph ~
  <https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm>

- When we have to explore all / most possibilities without a good pruning
  strategy, a DFS uses much less memory than a BFS

- [Day 16][day16] [comment / spoiler][src16]:
    - after having kept only the nodes with valves to open, explore all
      possibilities to open all valves with a buddy elephant is like
      partitioning the set of valves to open in two disjoint subsets. There was
      only 15 valves to open in my input. The number of interesting ways to
      split a set of 15 elements is 2<sup>15</sup>/2 = 16384.  Then for a given
      split, we can search for the max of my subset & the elephant's subset
      independently, by applying part one to each subset. With a fairly
      efficient part one (eg. a DFS that avoids already known states), it is
      good enough.

- [Day 19][day19] [comment / spoiler][src19]:
    - a pruning strategy to try for part two (not used) would be to define a
      score function, and keep track of the n best scores for each possible t
      (each step). Then at each examined state, if it is inside the n best,
      update the n best list and process the state, if not discard the state. r
    - Another not implemented strategy would be to decide that accumulating
      more ore, clay, ... than the max ore, clay, ...  possible to spend within
      the time left at a given step is useless, so discard all states that
      accumulate more that can be spent in the remaining time. And in the same
      line of idea, there is no point in building more ore, clay, ... robots
      (each producing one ore, clay, ... per minute) than the max ore, clay,
      ... cost (again this would lead to produce more material than we can
      spend). Discard these states too.
    - More tips read somewhere (not tried):
        - When you add the geode robot use appendleft so it gets searched first as it is often the best strategy.
        - You're calculating the max value of the costs of the robots for the ore but it only needs to run once not every state. 
        - Next is that the maximum amount of geodes from any state is if you can build a geode robot every time, if this maximum is less than the current best don't go any further as it is already beaten (2 * best > 2 * (current_geodes + geode_robots * t) + t^2 - t : continue)
        - time does not need to be a factor in the state that's in seen, it would if geodes were required to be spent to make something else.
        - if all robots can be made at this instance then you should never not build one as you are wasting time
        - no need to check if t == 0, if t==1 then the max geo you can have = current geode + geode robots as no more robots can be built.

[day16]: https://adventofcode.com/2022/day/16
[src16]: /src/16.py
[day19]: https://adventofcode.com/2022/day/19
[src19]: /src/19.py
