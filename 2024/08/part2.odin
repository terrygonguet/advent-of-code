package main

import "core:fmt"
import "core:slice"

part2 :: proc(stations: map[rune][dynamic]Vec2, dim: Vec2) -> (result: int, err: any) {
	antinodes := make(map[Vec2]bool)
	defer delete(antinodes)
	for freq, list in stations {
		for a, i in list {
			for b in list[i + 1:] {
				offset := b - a
				for an := a; is_in_bounds(an, dim); an += offset {
					antinodes[an] = true
				}
				for an := a - offset; is_in_bounds(an, dim); an -= offset {
					antinodes[an] = true
				}
			}
		}
	}

	return len(antinodes), nil
}
