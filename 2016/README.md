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
cmake --build cmake_build --target 11_exe test
```

Clean:

```
cmake --build cmake_build --target clean
```

Clean can also be run before other targets:

```
cmake --build cmake_build --clean-first
```

## Links

Advent of Code:

- <https://adventofcode.com>

Pharo Smalltalk:

- <https://pharo.org/>
