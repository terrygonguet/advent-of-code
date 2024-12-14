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

	robots := utils.map_ok(lines, parse_robot)
	defer delete(robots)

	// HACK
	_, is_puzzle := slice.linear_search_proc(robots, proc(robot: Robot) -> bool {
		return robot.pos.x >= 11 || robot.pos.y >= 7
	})
	bounds := Vec2{101, 103} if is_puzzle else Vec2{11, 7}

	if res1, err1 := part1(robots, bounds); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(robots, bounds); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

Robot :: struct {
	pos: Vec2,
	vel: Vec2,
}

parse_robot :: proc(str: string) -> (robot: Robot, ok: bool) {
	parts := strings.split(str, " ")
	defer delete(parts)

	if len(parts) != 2 do return

	strings.starts_with(parts[0], "p=") or_return
	nums_p := strings.split(parts[0][2:], ",")
	if len(nums_p) != 2 do return
	robot.pos.x = strconv.atoi(nums_p[0])
	robot.pos.y = strconv.atoi(nums_p[1])
	delete(nums_p)

	strings.starts_with(parts[1], "v=") or_return
	nums_v := strings.split(parts[1][2:], ",")
	if len(nums_v) != 2 do return
	robot.vel.x = strconv.atoi(nums_v[0])
	robot.vel.y = strconv.atoi(nums_v[1])
	delete(nums_v)

	return robot, true
}
