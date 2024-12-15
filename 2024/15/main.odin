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
	assert(err == nil, "Failed to read puzzle input")
	assert(len(puzzle) > 0, "Puzzle input is empty")

	game, ok := sokoban_parse(puzzle)
	assert(ok, "Failed to parse Sokoban")
	defer sokoban_destroy(game)

	game2, ok2 := sokoban_parse_2(puzzle)
	assert(ok2, "Failed to parse Sokoban v2")
	defer sokoban_destroy(game2)

	if res1, err1 := part1(&game); err == nil {
		fmt.println("Part 1: ", res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(&game2); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Vec2 :: [2]int

Block :: enum {
	Empty = 0,
	Wall,
	Box,
	BoxL,
	BoxR,
	Robot,
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

Sokoban :: struct {
	blocks: map[Vec2]Block,
	bounds: Vec2,
	moves:  []Direction,
}

sokoban_parse :: proc(str: string) -> (game: Sokoban, ok: bool) {
	parts := strings.split(str, "\n\n")
	defer delete(parts)
	if len(parts) != 2 do return

	y := 0
	for line in strings.split_lines_iterator(&parts[0]) {
		for char, x in line {
			pos := Vec2{x, y}
			switch char {
			case '#':
				game.blocks[pos] = .Wall
			case 'O':
				game.blocks[pos] = .Box
			case '@':
				game.blocks[pos] = .Robot
			}
			game.bounds.x = len(line)
			game.bounds.y = y + 1
		}
		y += 1
	}

	moves := make([dynamic]Direction)
	for char in parts[1] {
		switch char {
		case '^':
			append(&moves, Direction.Up)
		case 'v':
			append(&moves, Direction.Down)
		case '<':
			append(&moves, Direction.Left)
		case '>':
			append(&moves, Direction.Right)
		}
	}
	game.moves = moves[:]

	ok = true
	return
}

sokoban_parse_2 :: proc(str: string) -> (game: Sokoban, ok: bool) {
	parts := strings.split(str, "\n\n")
	defer delete(parts)
	if len(parts) != 2 do return

	y := 0
	for line in strings.split_lines_iterator(&parts[0]) {
		for char, x in line {
			posL := Vec2{2 * x, y}
			posR := Vec2{2 * x + 1, y}
			switch char {
			case '#':
				game.blocks[posL] = .Wall
				game.blocks[posR] = .Wall
			case 'O':
				game.blocks[posL] = .BoxL
				game.blocks[posR] = .BoxR
			case '@':
				game.blocks[posL] = .Robot
			}
			game.bounds.x = 2 * len(line)
			game.bounds.y = y + 1
		}
		y += 1
	}

	moves := make([dynamic]Direction)
	for char in parts[1] {
		switch char {
		case '^':
			append(&moves, Direction.Up)
		case 'v':
			append(&moves, Direction.Down)
		case '<':
			append(&moves, Direction.Left)
		case '>':
			append(&moves, Direction.Right)
		}
	}
	game.moves = moves[:]

	ok = true
	return
}

sokoban_destroy :: proc(game: Sokoban) {
	delete(game.blocks)
	delete(game.moves)
}

sokoban_debug :: proc(game: Sokoban, include_moves := true, move_index := -1) {
	using game
	for y in 0 ..< bounds.y {
		for x in 0 ..< bounds.x {
			switch blocks[Vec2{x, y}] {
			case .Wall:
				fmt.print("#")
			case .Box:
				fmt.print("O")
			case .BoxL:
				fmt.print("[")
			case .BoxR:
				fmt.print("]")
			case .Empty:
				fmt.print(".")
			case .Robot:
				if move_index == -1 do fmt.print("@")
				else do switch game.moves[move_index] {
				case .Up:
					fmt.print("^")
				case .Down:
					fmt.print("v")
				case .Left:
					fmt.print("<")
				case .Right:
					fmt.print(">")
				}
			}
		}
		fmt.print("\n")
	}

	if !include_moves do return

	for dir, i in moves {
		if i % 70 == 0 do fmt.print("\n")
		switch dir {
		case .Up:
			fmt.print("^")
		case .Down:
			fmt.print("v")
		case .Left:
			fmt.print("<")
		case .Right:
			fmt.print(">")
		}
	}

	fmt.print("\n")
}
