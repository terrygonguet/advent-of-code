package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:strings"

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	fmt.println("Part 1: ", part1(lines))
	fmt.println("Part 2: ", part2(lines))
}
