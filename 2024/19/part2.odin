package main

import "../utils"
import "core:fmt"
import "core:slice"

part2 :: proc(root: Thingie, designs: []string) -> (result: int, err: any) {
	root := root

	count_possible_design_rec = count_possible_design_cached
	result = utils.reduce_ctx(
		designs,
		&root,
		0,
		proc(sum: int, design: string, root: ^Thingie) -> int {
			return sum + count_possible_design(design, root, root)
		},
	)
	defer delete(cache)

	return
}

@(private = "file")
CacheKey :: struct {
	design: string,
	root:   ^Thingie,
	cur:    ^Thingie,
}

@(private = "file")
cache: map[CacheKey]int

@(private = "file")
count_possible_design_cached :: proc(design: string, root, cur: ^Thingie) -> int {
	key := CacheKey{design, root, cur}
	value, cached := cache[key]
	if cached do return value
	else {
		value := count_possible_design(design, root, cur)
		cache[key] = value
		return value
	}
}

@(private = "file")
count_possible_design_rec := count_possible_design
count_possible_design :: proc(design: string, root, cur: ^Thingie) -> int {
	if len(design) == 0 do return 1 if cur.is_terminal else 0
	else {
		stripe := Stripe(design[0])
		next, found := cur.children[stripe]
		can_make := count_possible_design_rec(design[1:], root, next) if found else 0
		if cur.is_terminal do return can_make + count_possible_design_rec(design, root, root)
		else do return can_make
	}
}
