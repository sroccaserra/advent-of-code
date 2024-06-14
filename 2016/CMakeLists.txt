cmake_minimum_required(VERSION 3.15)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED True)

add_compile_options(-W -Wall -Wextra -Wpedantic -Werror)

project(AdventOfCode2016 LANGUAGES C)
add_subdirectory(src/common)

function(add_target_for_day day_number)
    add_executable(${day_number}_exe src/${day_number}.c)
    target_link_libraries(${day_number}_exe PRIVATE common_lib)

    add_custom_target(run_${day_number} ALL
        COMMAND sh -c "./${day_number}_exe ../input/${day_number}")
endfunction()

add_target_for_day(11)

##
# Tests

enable_testing()

include(src/common/testing.cmake)

do_test(11_exe ../input/11 "0000003c00820341")
