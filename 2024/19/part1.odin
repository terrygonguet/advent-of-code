package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strings"

part1 :: proc(root: Thingie, designs: []string) -> (result: int, err: any) {
	root := root

	can_make_design_rec = can_make_design_cached
	possible_designs := utils.filter_ctx2(designs, &root, &root, can_make_design)
	defer delete(possible_designs)
	defer delete(cache)

	result = len(possible_designs)
	return
}

@(private = "file")
CacheKey :: struct {
	design: string,
	root:   ^Thingie,
	cur:    ^Thingie,
}

@(private = "file")
cache: map[CacheKey]bool

@(private = "file")
can_make_design_cached :: proc(design: string, root, cur: ^Thingie) -> bool {
	key := CacheKey{design, root, cur}
	value, cached := cache[key]
	if cached do return value
	else {
		// fmt.println("Caching:", design, root, cur)
		value := can_make_design(design, root, cur)
		cache[key] = value
		return value
	}
}

@(private = "file")
can_make_design_rec := can_make_design
can_make_design :: proc(design: string, root, cur: ^Thingie) -> bool {
	if len(design) == 0 do return cur.is_terminal
	else {
		stripe := Stripe(design[0])
		next, found := cur.children[stripe]
		can_make := found && can_make_design_rec(design[1:], root, next)
		if cur.is_terminal do return can_make || can_make_design_rec(design, root, root)
		else do return can_make
	}
}

towels_debug :: proc(root: Thingie, depth := 0) {
	if root.is_terminal {
		for i in 0 ..< depth do fmt.print("\t")
		fmt.println("[Terminal]")
	}
	for stripe, child_thingie in root.children {
		for i in 0 ..< depth do fmt.print("\t")
		fmt.println(stripe)
		towels_debug(child_thingie^, depth + 1)
	}
}
