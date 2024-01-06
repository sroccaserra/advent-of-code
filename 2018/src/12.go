package main

import (
	"aoc2018/src/common"
	"fmt"
)

func solve_12(initialState pots, config configuration) (int, int) {
	state := initialState
	nbGens_1 := 20
	var result_1 int
	previousSum := 9999999999999
	currentSum := state.numbersSum()
	previousDelta := 1
	currentDelta := 0
	generation := 1
	for true {
		previousSum = currentSum
		previousDelta = currentDelta
		state = state.nextGen(config)
		currentSum = state.numbersSum()
		currentDelta = currentSum - previousSum
		if generation == nbGens_1 {
			result_1 = state.numbersSum()
		}
		if currentDelta == previousDelta {
			break
		}
		generation++
	}
	stable_result := state.numbersSum()
	target_2 := 50000000000
	result_2 := stable_result + currentDelta*(target_2-generation)
	return result_1, result_2
}

type configuration = map[[5]int]int

type pots struct {
	minIndex int
	maxIndex int
	plantMap map[int]int
}

func (self pots) nextGen(config configuration) pots {
	nextMap := map[int]int{}
	self.minIndex -= 2
	self.maxIndex += 2
	for i := self.minIndex; i <= self.maxIndex; i++ {
		key := self.surroundings(i)
		nextMap[i] = config[key]
	}
	return pots{self.minIndex, self.maxIndex, nextMap}
}

func (self pots) surroundings(i int) [5]int {
	var result [5]int
	for j := 0; j < 5; j++ {
		result[j] = self.plantMap[i+j-2]
	}
	return result
}

func (self pots) numbersSum() int {
	var result int
	for i := self.minIndex; i <= self.maxIndex; i++ {
		if self.plantMap[i] == 1 {
			result += i
		}
	}
	return result
}

func (self pots) print() {
	for i := self.minIndex; i < 0; i++ {
		fmt.Print(" ")
	}
	fmt.Println("0")
	for i := self.minIndex; i <= self.maxIndex; i++ {
		v := self.plantMap[i]
		if v == 1 {
			fmt.Print("#")
		} else {
			fmt.Print(".")
		}
	}
	fmt.Println()
}

func parseInitialState(s string) pots {
	result := pots{0, len(s) - 1, map[int]int{}}
	for i, c := range s {
		if c == '#' {
			result.plantMap[i] = 1
		}
	}
	return result
}

func parseConfiguration(strings []string) configuration {
	result := map[[5]int]int{}
	for _, line := range strings {
		var lhs, rhs string
		fmt.Sscanf(line, "%s => %s", &lhs, &rhs)
		if rhs != "#" {
			continue
		}
		var key [5]int
		for i, c := range lhs {
			if c == '#' {
				key[i] = 1
			}
		}
		result[key] = 1
	}
	return result
}

func main() {
	lines := common.GetInputLines()
	firstLine := lines[0]
	initialState := parseInitialState(firstLine[15:])
	configuration := parseConfiguration(lines[2:])
	result_1, result_2 := solve_12(initialState, configuration)
	fmt.Println(result_1)
	fmt.Println(result_2)
}
