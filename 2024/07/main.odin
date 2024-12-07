package main

import "../utils"
import "core:fmt"
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

	eqs := make([dynamic]Eq)
	for line in lines {
		if eq, ok := parse_eq(line); ok {
			append(&eqs, eq)
		}
	}

	if res1, err1 := part1(eqs[:]); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(eqs[:]); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Eq :: struct {
	value:    int,
	operands: []int,
}

parse_eq :: proc(line: string) -> (eq: Eq, ok: bool) {
	parts := strings.split(line, ": ")
	if len(parts) != 2 do return eq, false
	eq.value = strconv.atoi(parts[0])
	ops := strings.split(parts[1], " ")
	eq.operands = slice.mapper(ops, proc(str: string) -> int {
		return strconv.atoi(str)
	})
	return eq, true
}
