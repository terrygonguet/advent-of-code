package main

import "core:fmt"
import "core:slice"

Direction :: enum {
	Up,
	Down,
	Left,
	Right,
}

offets :: [Direction]Vec2 {
	.Up    = {0, -1},
	.Down  = {0, 1},
	.Left  = {-1, 0},
	.Right = {1, 0},
}

part1 :: proc(terrain: Terrain) -> (result: int, err: any) {

	graph := make(map[Vec2][dynamic]Vec2)
	defer {
		for pos, connexions in graph {
			delete(connexions)
		}
		delete(graph)
	}

	trail_heads := make([dynamic]Vec2)
	defer delete(trail_heads)

	for x in 0 ..< terrain.width {
		for y in 0 ..< terrain.height {
			cur := terrain_at(terrain, x, y) or_continue
			if cur == 0 do append(&trail_heads, Vec2{x, y})
			for offset, dir in offets {
				pos := Vec2{x, y} + offset
				neighbour := terrain_at(terrain, pos) or_continue
				if neighbour == cur + 1 {
					connexions, found := &graph[{x, y}]
					if found do append(connexions, pos)
					else {
						connexions := make([dynamic]Vec2, 1)
						connexions[0] = pos
						graph[{x, y}] = connexions
					}
				}
			}
		}
	}

	for head in trail_heads {
		result += compute_score(terrain, graph, head)
	}

	return result, nil
}

compute_score :: proc(terrain: Terrain, graph: map[Vec2][dynamic]Vec2, pos: Vec2) -> int {
	summits := make(map[Vec2]bool)
	defer delete(summits)

	to_check := make([dynamic]Vec2, 1)
	defer delete(to_check)

	to_check[0] = pos
	for len(to_check) != 0 {
		cur := pop_front(&to_check)
		altitude := terrain_at(terrain, cur) or_continue
		if altitude == 9 do summits[cur] = true
		else {
			neighbours := graph[cur]
			append(&to_check, ..neighbours[:])
		}
	}

	return len(summits)
}
