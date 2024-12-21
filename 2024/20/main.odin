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

	bounds := Vec2{len(lines[0]), len(lines)}
	start, end: Vec2
	blocked := make(map[Vec2]bool)
	defer delete(blocked)

	for line, y in lines {
		for char, x in line {
			pos := Vec2{x, y}
			switch char {
			case '#':
				blocked[pos] = true
			case 'S':
				start = pos
			case 'E':
				end = pos
			}
		}
	}

	if res1, err1 := part1(blocked, bounds, start, end); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(blocked, bounds, start, end); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int
