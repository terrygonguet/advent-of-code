package main

import "../pathfinding"
import "../utils"
import "core:fmt"
import "core:slice"

part1 :: proc(points: []Vec2, bounds: Vec2) -> (result: int, err: any) {
	blocked := make(map[Vec2]bool)
	defer delete(blocked)

	duration := 1024 if len(points) >= 1024 else 12
	for i in 0 ..< duration {
		blocked[points[i]] = true
	}

	path, found := pathfinding.a_star_pathfind(blocked, bounds, {0, 0}, bounds - {1, 1})
	assert(found, "Can't find a path")
	defer delete(path)

	result = len(path) - 1

	return
}
