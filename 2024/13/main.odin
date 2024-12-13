package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:text/regex"

main :: proc() {
	when ODIN_DEBUG {
		tracking := utils.tracking_init()
		context.allocator = mem.tracking_allocator(&tracking)
		defer utils.tracking_cleanup(&tracking)
	}

	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	blocks := strings.split(puzzle, "\n\n")
	defer delete(blocks)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(blocks) > 0, "Puzzle input is empty")

	machines := utils.map_ok(blocks, parse_machine)
	defer delete(machines)

	if res1, err1 := part1(machines); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(machines); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]f64

Machine :: struct {
	a:     Vec2,
	b:     Vec2,
	prize: Vec2,
}

parse_machine :: proc(str: string) -> (machine: Machine, ok: bool) {
	lines := strings.split(str, "\n")
	defer delete(lines)

	strings.starts_with(lines[0], "Button A: ") or_return
	strings.starts_with(lines[1], "Button B: ") or_return
	strings.starts_with(lines[2], "Prize: ") or_return
	machine.a = parse_vec2(lines[0][10:]) or_return
	machine.b = parse_vec2(lines[1][10:]) or_return
	machine.prize = parse_vec2(lines[2][7:]) or_return

	ok = true
	return
}

@(private = "file")
reg_pos := create_reg_pos()

parse_vec2 :: proc(str: string) -> (pos: Vec2, ok: bool) {
	capture := regex.match(reg_pos, str) or_return
	defer regex.destroy(capture)
	return Vec2{strconv.atof(capture.groups[1]), strconv.atof(capture.groups[2])}, true
}

create_reg_pos :: proc() -> regex.Regular_Expression {
	reg_pos, reg_err := regex.create("X(?:\\+|=)(\\d+)\\,\\sY(?:\\+|=)(\\d+)", {.Global})
	assert(reg_err == nil, "Failed to create reg_pos RegExp")
	return reg_pos
}
