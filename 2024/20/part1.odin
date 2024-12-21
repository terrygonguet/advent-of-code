package main

import "../pathfinding"
import "../utils"
import "core:fmt"
import "core:slice"

part1 :: proc(blocked: map[Vec2]bool, bounds, start, end: Vec2) -> (result: int, err: any) {
	path, found := pathfinding.a_star_pathfind(blocked, bounds, start, end)
	defer delete(path)

	base_time := len(path) - 1
	time_saves := make(map[int]int)
	defer delete(time_saves)

	for cur, i in path {
		for target, delta in path[i:] {
			dist := target - cur
			if abs(dist.x) + abs(dist.y) <= 2 && delta > 2 {
				time_saves[delta - 2] += 1
			}
		}
	}

	for delta, n in time_saves {
		if delta >= 100 do result += n
	}

	return
}
