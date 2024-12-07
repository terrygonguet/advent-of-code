package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part2 :: proc(puzzle: string) -> (result: int, err: any) {
	parts := strings.split(puzzle, "\n\n")

	raw_rules := strings.split(parts[0], "\n")
	rules := make([dynamic]Rule)
	for raw_rule in raw_rules {
		if rule, ok := parse_rule(raw_rule); ok {
			append(&rules, rule)
		}
	}

	raw_updates := strings.split(parts[1], "\n")
	updates := make([dynamic][]int)
	for raw_update in raw_updates {
		if update, ok := parse_update(raw_update); ok {
			append(&updates, update)
		}
	}

	context.user_ptr = &rules
	for update in updates {
		is_sorted := slice.is_sorted_by(update, proc(a, b: int) -> bool {
			rules := (^[dynamic]Rule)(context.user_ptr)^
			idx, found := slice.linear_search(rules[:], Rule{b, a})
			return !found
		})
		if is_sorted do continue
		slice.sort_by(update, proc(a, b: int) -> bool {
			rules := (^[dynamic]Rule)(context.user_ptr)^
			idx, found := slice.linear_search(rules[:], Rule{b, a})
			return !found
		})
		mid := len(update) / 2
		result += update[mid]
	}

	return result, nil
}
