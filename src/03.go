package main

import (
	"fmt"

	"aoc2021/src/common"
)

func solve_03_1(lines []string) int {
	nbBits := len(lines[0])
	powOfTwo := 1 << (nbBits - 1)
	var gamma, epsilon int
	for i := 0; i < nbBits; i++ {
		var nbOnes, nbZeros int
		for _, line := range lines {
			if line[i] == '0' {
				nbZeros++
			} else {
				nbOnes++
			}
		}
		if nbOnes > nbZeros {
			gamma += powOfTwo
		} else {
			epsilon += powOfTwo
		}
		powOfTwo >>= 1
	}
	return gamma * epsilon
}

func main() {
	lines := common.GetInputLines()
	fmt.Println(solve_03_1(lines))
}
