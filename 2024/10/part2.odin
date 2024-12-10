package main

import "core:fmt"
import "core:slice"

part2 :: proc(terrain: Terrain) -> (result: int, err: any) {

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
		result += compute_score_2(terrain, graph, head)
	}

	return result, nil
}

compute_score_2 :: proc(terrain: Terrain, graph: map[Vec2][dynamic]Vec2, pos: Vec2) -> int {
	altitude, in_bounds := terrain_at(terrain, pos)
	if !in_bounds do return 0
	if altitude == 9 do return 1

	score := 0
	neighbours := graph[pos]
	for neighbour in neighbours {
		score += compute_score_2(terrain, graph, neighbour)
	}

	return score
}
