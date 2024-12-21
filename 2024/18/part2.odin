package main

import "../pathfinding"
import "../utils"
import "core:fmt"
import "core:slice"

part2 :: proc(points: []Vec2, bounds: Vec2) -> (result: Vec2, err: any) {
	blocked := make(map[Vec2]bool)
	defer delete(blocked)

	for i := 0;; i += 1 {
		blocked[points[i]] = true
		path, found := pathfinding.a_star_pathfind(blocked, bounds, {0, 0}, bounds - {1, 1})
		defer delete(path)
		if !found {
			result = points[i]
			break
		}
	}

	return
}
