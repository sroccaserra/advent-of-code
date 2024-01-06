# Learning from https://www.r-bloggers.com/2020/12/advent-of-code-2020/

partOne <- function(xs) {
    prod(xs[(2020 - xs) %in% xs])
}

partTwo <- function(xs) {
    # simple but slow:
    # return(prod(combn(input, 3)[, combn(input, 3, sum) == 2020]))

    . <- expand.grid(xs, xs[(2020 - xs) > min(xs)])
    . <- transform(., Var3 = 2020 - Var1 - Var2)
    . <- subset(., Var3 > min(xs))

    prod(.[which.max(.$Var3 %in% xs), ])
}

input <- as.integer(readLines('src/Day01.txt'))
partOne(input)
partTwo(input)
