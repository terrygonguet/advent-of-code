package main

import "../utils"
import "core:fmt"
import "core:slice"

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}

cardinals :: [Direction]Vec2 {
	.Up    = {0, -1},
	.Down  = {0, 1},
	.Left  = {-1, 0},
	.Right = {1, 0},
}

part1 :: proc(plots: []rune, dim: Vec2) -> (result: int, err: any) {
	regions := make(map[rune][dynamic]map[Vec2]bool)
	defer {
		for plant, candidates in regions {
			for region in candidates {
				delete(region)
			}
			delete(candidates)
		}
		delete(regions)
	}

	visited := make(map[Vec2]bool)
	defer delete(visited)

	for x in 0 ..< dim.x {
		for y in 0 ..< dim.y {
			pos := Vec2{x, y}
			if visited[pos] do continue

			region := flood(plots, dim, pos)
			for new_pos in region {
				visited[new_pos] = true
			}

			plant := plots[xy_to_i(x, y, dim)]
			candidates := regions[plant]
			append(&candidates, region)
			regions[plant] = candidates
		}
	}

	for plant, candidates in regions {
		for region in candidates {
			result += area(region) * perimeter(region)
		}
	}

	return result, nil
}

perimeter :: proc(region: map[Vec2]bool) -> int {
	sum := 0

	for plot in region {
		sum += 0 if region[plot + cardinals[.Up]] else 1
		sum += 0 if region[plot + cardinals[.Down]] else 1
		sum += 0 if region[plot + cardinals[.Left]] else 1
		sum += 0 if region[plot + cardinals[.Right]] else 1
	}

	return sum
}

area :: proc(region: map[Vec2]bool) -> int {
	return len(region)
}

flood :: proc(
	plots: []rune,
	dim: Vec2,
	start: Vec2,
	allocator := context.allocator,
	temp_allocator := context.temp_allocator,
) -> map[Vec2]bool {
	region := make(map[Vec2]bool, allocator)
	plant := plots[vec2_to_i(start, dim)]
	candidates := make([dynamic]Vec2, temp_allocator)
	defer delete(candidates)

	append(&candidates, start)
	append(&candidates, start + cardinals[.Up])
	append(&candidates, start + cardinals[.Down])
	append(&candidates, start + cardinals[.Left])
	append(&candidates, start + cardinals[.Right])

	for len(candidates) > 0 {
		cur_pos := pop_front(&candidates)
		if !is_in_bounds(cur_pos, dim) || region[cur_pos] do continue

		cur_plant := plots[vec2_to_i(cur_pos, dim)]
		if plant != cur_plant do continue

		region[cur_pos] = true
		append(&candidates, cur_pos + cardinals[.Up])
		append(&candidates, cur_pos + cardinals[.Down])
		append(&candidates, cur_pos + cardinals[.Left])
		append(&candidates, cur_pos + cardinals[.Right])
	}

	return region
}
