package main

import "../utils"
import "core:fmt"
import "core:slice"

Node :: struct {
	pos: Vec2,
	dir: Direction,
}

Candidate :: struct {
	node: Node,
	cost: int,
}

part1 :: proc(maze: Maze) -> (result: int, err: any) {
	costs := make(map[Node]int)
	defer delete(costs)

	start_pos := utils.linear_search_key(maze.tiles, Tile.Start) or_return
	to_check := make([dynamic]Candidate, 1)
	defer delete(to_check)
	to_check[0] = {
		node = {start_pos, .Right},
		cost = 0,
	}

	for len(to_check) > 0 {
		candidate := pop_front(&to_check)
		tile := maze.tiles[candidate.node.pos]
		if tile == .Wall do continue
		cur_cost, found := costs[candidate.node]
		if !found || cur_cost > candidate.cost {
			costs[candidate.node] = candidate.cost
			append(&to_check, Candidate{forward(candidate.node), candidate.cost + 1})
			append(&to_check, Candidate{rotate_cw(candidate.node), candidate.cost + 1000})
			append(&to_check, Candidate{rotate_ccw(candidate.node), candidate.cost + 1000})
		}
	}

	result = 99999999999
	for node, cost in costs {
		tile := maze.tiles[node.pos]
		if tile == .End {
			result = min(result, cost)
		}
	}

	return
}

forward :: proc(node: Node) -> Node {
	using node
	return {pos = pos + step[dir], dir = dir}
}

rotate_cw :: proc(node: Node) -> Node {
	using node
	switch dir {
	case .Up:
		return {pos, .Right}
	case .Down:
		return {pos, .Left}
	case .Left:
		return {pos, .Up}
	case .Right:
		return {pos, .Down}
	}
	return node
}

rotate_ccw :: proc(node: Node) -> Node {
	using node
	switch dir {
	case .Up:
		return {pos, .Left}
	case .Down:
		return {pos, .Right}
	case .Left:
		return {pos, .Down}
	case .Right:
		return {pos, .Up}
	}
	return node
}
