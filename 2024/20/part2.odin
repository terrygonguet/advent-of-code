package main

import "../pathfinding"
import "../utils"
import "core:fmt"
import "core:slice"

part2 :: proc(blocked: map[Vec2]bool, bounds, start, end: Vec2) -> (result: int, err: any) {
	path, found := pathfinding.a_star_pathfind(blocked, bounds, start, end)
	defer delete(path)

	base_time := len(path) - 1
	time_saves := make(map[int]int)
	defer delete(time_saves)

	for cur, i in path {
		for target, j in path[i:] {
			dist := abs(target.x - cur.x) + abs(target.y - cur.y)
			if dist <= 20 && j > dist {
				time_saves[j - dist] += 1
			}
		}
	}

	for delta, n in time_saves {
		if delta >= 100 do result += n
	}

	return
}
