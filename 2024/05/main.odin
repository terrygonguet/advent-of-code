package main

import "../utils"
import "core:fmt"
import "core:strings"

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(puzzle) > 0, "Puzzle input is empty")

	if res1, err1 := part1(puzzle); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(puzzle); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}
