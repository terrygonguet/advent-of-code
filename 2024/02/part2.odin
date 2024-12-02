package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part2 :: proc(lines: []string) -> int {
	levels := slice.mapper(lines, parse_line)
	safe := slice.filter(levels, is_safe_2)
	return len(safe)
}

is_safe_2 :: proc(levels: []int) -> bool {
	ignores: for joker := -1; joker < len(levels); joker += 1 {
		order := get_order(levels[0], levels[1])
		if joker == 0 do order = get_order(levels[1], levels[2])
		if joker == 1 do order = get_order(levels[0], levels[2])
		if order == .Flat do continue ignores
		prev := levels[1] if joker == 0 else levels[0]
		start := 2 if joker == 0 else 1
		for i := start; i < len(levels); i += 1 {
			if joker == i do continue
			cur := levels[i]
			curOrder := get_order(prev, cur)
			if order != curOrder do continue ignores
			delta := abs(prev - cur)
			if delta > 3 do continue ignores
			prev = cur
		}
		return true
	}
	return false
}
