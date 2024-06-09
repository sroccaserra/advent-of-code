cmake_minimum_required(VERSION 3.15)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)

add_compile_options(-W -Wall -Wextra -Wpedantic -Werror)

project(AdventOfCode2016 LANGUAGES C)

add_subdirectory(src/common)

add_executable(11 src/11.c)

target_link_libraries(11 PRIVATE Common)

##
# Tests

enable_testing()

function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg}
    PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endfunction()

do_test(11 ../input/11 "0000003c00820341")
