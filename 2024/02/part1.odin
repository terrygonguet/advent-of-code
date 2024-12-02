package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part1 :: proc(lines: []string) -> int {
	levels := slice.mapper(lines, parse_line)
	safe := slice.filter(levels, is_safe)
	return len(safe)
}

parse_line :: proc(line: string) -> []int {
	ns := strings.split(line, " ")
	levels := make([]int, len(ns))
	defer delete(ns)
	for n, i in ns {
		levels[i] = strconv.atoi(n)
	}
	return levels
}

Order :: enum {
	Asc,
	Desc,
	Flat,
}

is_safe :: proc(levels: []int) -> bool {
	order := get_order(levels[0], levels[1])
	if order == .Flat do return false
	prev := levels[0]
	for i := 1; i < len(levels); i += 1 {
		cur := levels[i]
		curOrder := get_order(prev, cur)
		if order != curOrder do return false
		delta := abs(prev - cur)
		if delta > 3 do return false
		prev = cur
	}
	return true
}

get_order :: proc(a: int, b: int) -> Order {
	delta := a - b
	if delta > 0 do return .Desc
	else if delta < 0 do return .Asc
	else do return .Flat
}
