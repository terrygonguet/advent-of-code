package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strconv"

@(private = "file")
Block :: struct {
	size: int,
	id:   union {
		int,
	},
}

part2 :: proc(puzzle: string) -> (result: int, err: any) {
	blocks: [dynamic]Block
	defer delete(blocks)
	is_block := true
	block_id := 0
	for char in puzzle {
		size := strconv._digit_value(char)
		if size != 0 {
			block := Block {
				size = size,
				id   = block_id if is_block else nil,
			}
			append(&blocks, block)
		}
		is_block = !is_block
		if is_block do block_id += 1
	}

	prev_id := 99999999
	for i := len(blocks) - 1; i >= 0; i -= 1 {
		block := blocks[i]
		switch id in block.id {
		case int:
			if id > prev_id do continue
			else do prev_id = id
		case:
			continue
		}

		j, found := utils.linear_search_ctx(blocks[:], block, proc(cur, block: Block) -> bool {
			return cur.id == nil && cur.size >= block.size
		})
		if j > i || !found do continue

		empty := blocks[j]
		slice.swap(blocks[:], i, j)
		if empty.size > block.size {
			blocks[i].size = block.size
			new_block := Block {
				size = empty.size - block.size,
				id   = nil,
			}
			inject_at(&blocks, j + 1, new_block)
			i += 1
		}
	}

	i := 0
	for block in blocks {
		switch id in block.id {
		case int:
			for j in 0 ..< block.size do result += id * (i + j)
		}
		i += block.size
	}

	return result, nil
}
