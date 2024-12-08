package main

import "core:fmt"
import "core:slice"

part1 :: proc(stations: map[rune][dynamic]Vec2, dim: Vec2) -> (result: int, err: any) {
	antinodes := make(map[Vec2]bool)
	defer delete(antinodes)
	for freq, list in stations {
		for a, i in list {
			for b in list[i + 1:] {
				offset := b - a
				an1 := a + offset * 2
				if is_in_bounds(an1, dim) do antinodes[an1] = true
				an2 := a - offset
				if is_in_bounds(an2, dim) do antinodes[an2] = true
			}
		}
	}

	return len(antinodes), nil
}

is_in_bounds :: proc(a, bounds: Vec2) -> bool {
	return a.x >= 0 && a.x < bounds.x && a.y >= 0 && a.y < bounds.y
}
