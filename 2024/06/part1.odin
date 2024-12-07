package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part1 :: proc(boxes: map[Vec2]bool, guard: Guard, dim: Vec2) -> (result: int, err: any) {
	guard := guard
	visited := make(map[Vec2]bool)
	defer delete(visited)
	visited[guard.pos] = true
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
			visited[next] = true
			guard.pos = next
		}
	}
	return len(visited) - 1, nil
}
