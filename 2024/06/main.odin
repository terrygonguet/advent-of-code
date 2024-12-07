package main

import "../utils"
import "core:fmt"
import "core:strings"

Vec2 :: [2]int

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}

Guard :: struct {
	pos: Vec2,
	dir: Direction,
}

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	boxes := make(map[Vec2]bool)
	defer delete(boxes)
	guard := Guard {
		pos = {0, 0},
		dir = .Up,
	}

	for line, y in lines {
		for char, x in line {
			if char == '#' do boxes[{x, y}] = true
			if char == '^' do guard.pos = {x, y}
		}
	}

	dim := Vec2{len(lines[0]), len(lines)}

	if res1, err1 := part1(boxes, guard, dim); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(boxes, guard, dim); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}
