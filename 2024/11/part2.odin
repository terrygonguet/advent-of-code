package main

import "core:fmt"
import "core:slice"

part2 :: proc(stones: []int) -> (result: int, err: any) {
	values: map[int]int
	defer delete(values)
	for stone in stones {
		values[stone] += 1
	}

	for n in 0 ..< 75 {
		new_values: map[int]int
		for stone, num in values {
			if stone == 0 do new_values[1] += num
			else if a, b, can_split := split(stone); can_split {
				new_values[a] += num
				new_values[b] += num
			} else do new_values[stone * 2024] += num
		}
		delete(values)
		values = new_values
	}

	for stone, num in values {
		result += num
	}

	return result, nil
}
