package main

import "core:fmt"
import "core:slice"
import "core:strconv"

part1 :: proc(stones: []int) -> (result: int, err: any) {
	stones := slice.clone_to_dynamic(stones)
	defer delete(stones)

	for n in 0 ..< 25 {
		for i := 0; i < len(stones); i += 1 {
			stone := stones[i]
			if stone == 0 do stones[i] = 1
			else if a, b, can_split := split(stone); can_split {
				stones[i] = a
				inject_at(&stones, i + 1, b)
				i += 1
			} else do stones[i] = stone * 2024
		}
	}

	return len(stones), nil
}

split :: proc(stone: int) -> (a, b: int, can_split: bool) {
	@(static) buf: [64]byte
	digits := strconv.itoa(buf[:], stone)
	if len(digits) % 2 != 0 do return 0, 0, false
	a = strconv.atoi(digits[:len(digits) / 2])
	b = strconv.atoi(digits[len(digits) / 2:])
	can_split = true
	return
}
