package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

Vec2 :: [2]int

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	stations := make(map[rune][dynamic]Vec2)
	defer delete(stations)

	for line, y in lines {
		for char, x in line {
			if char == '.' do continue
			list, ok := &stations[char]
			if ok do append(list, Vec2{x, y})
			else {
				list := make([dynamic]Vec2, 1)
				list[0] = {x, y}
				stations[char] = list
			}
		}
	}

	dim := Vec2{len(lines[0]), len(lines)}

	if res1, err1 := part1(stations, dim); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(stations, dim); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}
