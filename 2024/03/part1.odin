package main

import "core:fmt"
import "core:strconv"
import "core:text/regex"

part1 :: proc(puzzle: string) -> int {
	puzzle := puzzle
	reg_exp, err := regex.create("mul\\((\\d{1,3}),(\\d{1,3})\\)", {.Global})
	if err != nil do fmt.panicf("Cannot create Regexp: %v", err)
	defer regex.destroy(reg_exp)

	total := 0
	for {
		capture, ok := regex.match(reg_exp, puzzle)
		defer regex.destroy(capture)
		if len(capture.groups) == 0 do break

		a := strconv.atoi(capture.groups[1])
		b := strconv.atoi(capture.groups[2])
		total += a * b

		match_pos := capture.pos[0]
		puzzle = puzzle[match_pos[1]:]
	}

	return total
}
