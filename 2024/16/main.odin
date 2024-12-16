package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	when ODIN_DEBUG {
		tracking := utils.tracking_init()
		context.allocator = mem.tracking_allocator(&tracking)
		defer utils.tracking_cleanup(&tracking)
	}

	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	maze: Maze
	defer delete(maze.tiles)

	maze.bounds = {len(lines[0]), len(lines)}
	for line, y in lines {
		for char, x in line {
			pos := Vec2{x, y}
			switch char {
			case '#':
				maze.tiles[pos] = .Wall
			case 'S':
				maze.tiles[pos] = .Start
			case 'E':
				maze.tiles[pos] = .End
			}
		}
	}

	if res1, err1 := part1(maze); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(maze); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

Tile :: enum {
	Empty = 0,
	Wall,
	Start,
	End,
}

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}

up :: Vec2{0, -1}
down :: Vec2{0, 1}
left :: Vec2{-1, 0}
right :: Vec2{1, 0}
step := [Direction]Vec2 {
	.Up    = up,
	.Down  = down,
	.Left  = left,
	.Right = right,
}

Maze :: struct {
	tiles:  map[Vec2]Tile,
	bounds: Vec2,
}
