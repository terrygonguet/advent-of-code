package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part1 :: proc(lines: []string) -> int {
	left := make([dynamic]int, len(lines))
	defer delete(left)
	right := make([dynamic]int, len(lines))
	defer delete(right)

	for line, i in lines {
		numbers := strings.split(line, "   ")
		defer delete(numbers)

		if len(numbers) != 2 do panic(strings.concatenate({"Unexpected line: ", line}))

		left[i] = strconv.atoi(numbers[0])
		right[i] = strconv.atoi(numbers[1])
	}
	assert(len(left) == len(lines))
	assert(len(right) == len(lines))

	slice.sort(left[:])
	slice.sort(right[:])

	total := 0
	for i := 0; i < len(lines); i += 1 {
		total += abs(left[i] - right[i])
	}

	return total
}
