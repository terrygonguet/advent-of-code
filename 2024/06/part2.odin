package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part2 :: proc(boxes: map[Vec2]bool, guard: Guard, dim: Vec2) -> (result: int, err: any) {
	boxes := boxes
	for x in 0 ..< dim.x {
		for y in 0 ..< dim.y {
			cur := Vec2{x, y}
			if cur in boxes || cur == guard.pos do continue

			boxes[cur] = true
			if has_loop(boxes, guard, dim) do result += 1
			delete_key(&boxes, cur)
		}
	}
	return result, nil
}

has_loop :: proc(boxes: map[Vec2]bool, guard: Guard, dim: Vec2) -> bool {
	guard := guard
	visited := make(map[Guard]bool)
	defer delete(visited)
	visited[guard] = true
	for guard.pos.x >= 0 && guard.pos.y >= 0 && guard.pos.x < dim.x && guard.pos.y < dim.y {
		next: Vec2
		switch guard.dir {
		case .Up:
			next = {guard.pos.x, guard.pos.y - 1}
		case .Down:
			next = {guard.pos.x, guard.pos.y + 1}
		case .Left:
			next = {guard.pos.x - 1, guard.pos.y}
		case .Right:
			next = {guard.pos.x + 1, guard.pos.y}
		}
		if next in boxes {
			switch guard.dir {
			case .Up:
				guard.dir = .Right
			case .Down:
				guard.dir = .Left
			case .Left:
				guard.dir = .Up
			case .Right:
				guard.dir = .Down
			}
		} else {
			guard.pos = next
		}
		if guard in visited do return true
		visited[guard] = true
	}
	return false
}
