cmake_minimum_required(VERSION 3.15)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)

add_compile_options(-W -Wall -Wextra -Wpedantic -Werror)

project(AdventOfCode2016 LANGUAGES C)
add_executable(11_exe src/11.c)
add_subdirectory(src/common)
target_link_libraries(11_exe PRIVATE common_lib)

##
# Tests

enable_testing()

include(src/common/testing.cmake)

do_test(11_exe ../input/11 "0000003c00820341")
