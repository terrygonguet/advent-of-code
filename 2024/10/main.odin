package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	terrain := terrain_make(len(lines[0]), len(lines))
	defer terrain_destroy(terrain)
	for line, y in lines {
		for char, x in line {
			terrain_set(terrain, x, y, strconv._digit_value(char))
		}
	}

	if res1, err1 := part1(terrain); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(terrain); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

Terrain :: struct {
	width:  int,
	height: int,
	tiles:  []int,
}

terrain_make :: proc(w, h: int, allocator := context.allocator) -> Terrain {
	tiles := make([]int, w * h, allocator)
	return Terrain{width = w, height = h, tiles = tiles}
}

terrain_destroy :: proc(terrain: Terrain, allocator := context.allocator) {
	delete(terrain.tiles, allocator)
}

terrain_at_xy :: proc(terrain: Terrain, x, y: int) -> (value: int, ok: bool) {
	using terrain
	if x < 0 || y < 0 || x >= width || y >= height do return -1, false
	return tiles[y * width + x], true
}

terrain_at_vec :: proc(terrain: Terrain, pos: Vec2) -> (value: int, ok: bool) {
	return terrain_at_xy(terrain, pos.x, pos.y)
}

terrain_at :: proc {
	terrain_at_vec,
	terrain_at_xy,
}

terrain_set :: proc(terrain: Terrain, x, y, value: int) {
	terrain.tiles[y * terrain.width + x] = value
}

terrain_debug :: proc(terrain: Terrain) {
	using terrain
	fmt.println(width, "x", height)
	for y in 0 ..< height {
		for x in 0 ..< width {
			fmt.print(tiles[y * width + x])
		}
		fmt.print("\n")
	}
}
