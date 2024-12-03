package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:strings"

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(puzzle) > 0, "Puzzle input is empty")

	fmt.println("Part 1: ", part1(puzzle))
	fmt.println("Part 2: ", part2(puzzle))
}
