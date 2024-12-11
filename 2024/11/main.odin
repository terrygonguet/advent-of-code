package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(puzzle) > 0, "Puzzle input is empty")

	ns := strings.split(puzzle, " ")
	defer delete(ns)

	stones := make([]int, len(ns))
	defer delete(stones)

	for n, i in ns {
		stones[i] = strconv.atoi(n)
	}

	if res1, err1 := part1(stones); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(stones); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}
