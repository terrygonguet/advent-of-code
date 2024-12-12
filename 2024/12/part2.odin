package main

import "core:fmt"
import "core:slice"

part2 :: proc(plots: []rune, dim: Vec2) -> (result: int, err: any) {
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
			result += area(region) * sides(region)
		}
	}

	return result, nil
}

sides :: proc(region: map[Vec2]bool) -> int {
	sum := 0

	for pos in region {
		a := 1 if region[pos + cardinals[.Up]] else 0
		b := 1 if region[pos + cardinals[.Down]] else 0
		c := 1 if region[pos + cardinals[.Left]] else 0
		d := 1 if region[pos + cardinals[.Right]] else 0
		num := a + b + c + d
		if num == 0 do sum += 4
		else if num == 1 do sum += 2
		else if num == 2 && a != b && c != d do sum += 1

		// inner corners
		if a == 1 && d == 1 && !region[pos + cardinals[.Up] + cardinals[.Right]] do sum += 1
		if a == 1 && c == 1 && !region[pos + cardinals[.Up] + cardinals[.Left]] do sum += 1
		if b == 1 && d == 1 && !region[pos + cardinals[.Down] + cardinals[.Right]] do sum += 1
		if b == 1 && c == 1 && !region[pos + cardinals[.Down] + cardinals[.Left]] do sum += 1
	}

	return sum
}
