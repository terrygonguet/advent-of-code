package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strings"

part2 :: proc(towels: []string, designs: []string) -> (result: int, err: any) {
	result = utils.reduce_ctx(
		designs,
		towels,
		0,
		proc(sum: int, design: string, towels: []string) -> int {
			return sum + count_possible_design(design, towels)
		},
	)
	defer delete(cache)

	return
}

@(private = "file")
cache: map[string]int

@(private = "file")
count_possible_design_cached :: proc(design: string, towels: []string) -> int {
	value, cached := cache[design]
	if cached do return value
	else {
		value := count_possible_design(design, towels)
		cache[design] = value
		return value
	}
}

count_possible_design :: proc(design: string, towels: []string) -> int {
	total := 0
	for towel in towels {
		if towel == design do total += 1
		if strings.starts_with(
			design,
			towel,
		) {total += count_possible_design_cached(design[len(towel):], towels)}
	}
	return total
}
