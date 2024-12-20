package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strings"

part1 :: proc(towels: []string, designs: []string) -> (result: int, err: any) {
	possible_designs := utils.filter_ctx(designs, towels, can_make_design)
	defer delete(possible_designs)
	defer delete(cache)

	result = len(possible_designs)
	return
}

@(private = "file")
cache: map[string]bool

@(private = "file")
can_make_design_cached :: proc(design: string, towels: []string) -> bool {
	value, cached := cache[design]
	if cached do return value
	else {
		value := can_make_design(design, towels)
		cache[design] = value
		return value
	}
}

can_make_design :: proc(design: string, towels: []string) -> bool {
	for towel in towels {
		if towel == design do return true
		if strings.starts_with(design, towel) &&
		   can_make_design_cached(design[len(towel):], towels) {return true}
	}
	return false
}
