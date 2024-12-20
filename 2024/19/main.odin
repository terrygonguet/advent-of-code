package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"

Stripe :: enum {
	Red   = 'r',
	Green = 'g',
	Blue  = 'u',
	White = 'w',
	Black = 'b',
}

Thingie :: struct {
	is_terminal: bool,
	children:    map[Stripe]^Thingie,
}

main :: proc() {
	when ODIN_DEBUG {
		tracking := utils.tracking_init()
		context.allocator = mem.tracking_allocator(&tracking)
		defer utils.tracking_cleanup(&tracking)
	}

	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	towels := strings.split(lines[0], ", ")
	defer delete(towels)
	designs := lines[2:]

	root: Thingie
	defer thingie_destroy(&root, is_root = true)

	for towel in towels {
		cur_thingie := &root
		for char in towel {
			stripe := Stripe(char)
			next_thingie, exists := cur_thingie.children[stripe]
			if !exists {
				cur_thingie.children[stripe] = new(Thingie)
			}
			cur_thingie = cur_thingie.children[stripe]
		}
		cur_thingie.is_terminal = true
	}

	if res1, err1 := part1(root, designs); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(root, designs); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

thingie_destroy :: proc(thingie: ^Thingie, is_root := false) {
	for _, child in thingie.children {
		thingie_destroy(child)
	}
	delete(thingie.children)
	if !is_root do free(thingie)
}
