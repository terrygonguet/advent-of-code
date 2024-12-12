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
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	dim := Vec2{len(lines[0]), len(lines)}
	plots := make([]rune, dim.x * dim.y)
	defer delete(plots)
	for line, y in lines {
		for char, x in line {
			plots[xy_to_i(x, y, dim)] = char
		}
	}

	if res1, err1 := part1(plots, dim); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(plots, dim); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

vec2_to_i :: proc(pos, dim: Vec2) -> int {
	return pos.y * dim.x + pos.x
}

xy_to_i :: proc(x, y: int, dim: Vec2) -> int {
	return y * dim.x + x
}

is_in_bounds :: proc(pos, dim: Vec2) -> bool {
	return pos.x >= 0 && pos.y >= 0 && pos.x < dim.x && pos.y < dim.y
}
