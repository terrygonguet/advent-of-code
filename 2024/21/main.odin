package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	when ODIN_DEBUG {
		tracking := utils.tracking_init()
		context.allocator = mem.tracking_allocator(&tracking)
		defer utils.tracking_cleanup(&tracking)
	}

	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	if res1, err1 := part1(lines); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(lines); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

num_keypad := map[rune]Vec2 {
	'A' = {2, 3},
	'0' = {1, 3},
	'1' = {0, 2},
	'2' = {1, 2},
	'3' = {2, 2},
	'4' = {0, 1},
	'5' = {1, 1},
	'6' = {2, 1},
	'7' = {0, 0},
	'8' = {1, 0},
	'9' = {2, 0},
}

DirKeypress :: enum {
	Accept,
	Up,
	Down,
	Left,
	Right,
}

dir_keypad := [DirKeypress]Vec2 {
	.Accept = {2, 0},
	.Up     = {1, 0},
	.Down   = {1, 1},
	.Left   = {0, 1},
	.Right  = {2, 1},
}

vec2_dist :: proc(a, b: Vec2) -> int {
	delta := b - a
	return abs(delta.x) + abs(delta.y)
}
