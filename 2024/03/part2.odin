package main

import "core:strconv"
import "core:text/regex"

part2 :: proc(puzzle: string) -> (total: int, err: regex.Error) {
	puzzle := puzzle

	reg_exp := regex.create(
		`(?:mul\((\d{1,3}),(\d{1,3})\))|(?:do\(\))|(?:don't\(\))`,
		{.Global},
	) or_return
	defer regex.destroy(reg_exp)

	mul_enabled := true
	for {
		capture := regex.match(reg_exp, puzzle) or_break
		defer regex.destroy(capture)
		if len(capture.groups) == 0 do break

		switch capture.groups[0] {
		case "do()":
			mul_enabled = true
		case "don't()":
			mul_enabled = false
		case:
			if mul_enabled {
				a := strconv.atoi(capture.groups[1])
				b := strconv.atoi(capture.groups[2])
				total += a * b
			}
		}

		puzzle = puzzle[capture.pos[0][1]:]
	}

	return total, nil
}
