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

	points := utils.map_ok(lines, point_parse)
	defer delete(points)
	bounds := slice.reduce(points, Vec2{0, 0}, proc(bounds, point: Vec2) -> Vec2 {
		return {max(bounds.x, point.x), max(bounds.y, point.y)}
	})
	bounds += {1, 1}

	if res1, err1 := part1(points, bounds); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(points, bounds); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

point_parse :: proc(str: string) -> (point: Vec2, ok: bool) {
	idx := strings.index_rune(str, ',')
	if idx == -1 do return
	point.x = strconv.atoi(str[:idx])
	point.y = strconv.atoi(str[idx + 1:])
	ok = true
	return
}
