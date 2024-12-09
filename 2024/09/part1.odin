package main

import "core:fmt"
import "core:slice"
import "core:strconv"

@(private = "file")
Block :: union {
	u32,
}

part1 :: proc(puzzle: string) -> (result: int, err: any) {
	blocks: [dynamic]Block
	defer delete(blocks)
	is_block := true
	block_id: u32 = 0
	for block in puzzle {
		size := strconv._digit_value(block)
		for i := 0; i < size; i += 1 {
			append(&blocks, Block((block_id)) if is_block else Block(nil))
		}
		is_block = !is_block
		if is_block do block_id += 1
	}

	first_empty := 0
	for blocks[first_empty] != nil do first_empty += 1

	#reverse for block, i in blocks {
		if block == nil do continue
		if first_empty > i do break
		slice.swap(blocks[:], i, first_empty)
		for blocks[first_empty] != nil do first_empty += 1
	}

	for block, i in blocks {
		switch b in block {
		case u32:
			result += i * int(b)
		case:
			break
		}
	}

	return result, nil
}
