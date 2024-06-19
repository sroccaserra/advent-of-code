Solving Advent of Code 2016 problems.

## Using CMake

Initialization from root dir:

```
$ mkdir cmake_build
$ cd cmake_build
$ cmake ..
```

Building from root dir:

```
cmake --build cmake_build
```

Build and run tests:

```
cmake --build cmake_build --target 11_exe 11_test
```

Clean:

```
cmake --build cmake_build --target clean
```

Clean can also be run before other targets:

```
cmake --build cmake_build --clean-first
```

## My WIP C coding standard

Use K&R as a base for notation. E.g. `char *line` or `char
**lines`.

Functions that define the dynamic array interface:
- Have the dynamic array as their first argument
- Start with the `da_` prefix, e.g. `da_size()` or `da_push()`

Functions that are not part of the dynamic array inteface but
return dynamic arrays, or work specifically on a dynamic array
end with the `_da` prefix. E.g.  `get_lines_da()` or
`free_lines_da()`.

## Links

Advent of Code:

- <https://adventofcode.com>

Pharo Smalltalk:

- <https://pharo.org/>
