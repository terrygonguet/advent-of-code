package main

import "../utils"
import "core:fmt"
import "core:slice"

Thingie :: struct {
	cost:  int,
	edges: [dynamic]Node,
}

part2 :: proc(maze: Maze) -> (result: int, err: any) {
	graph := make(map[Node]Thingie)
	defer {
		for node, thingie in graph {
			delete(thingie.edges)
		}
		delete(graph)
	}

	start_pos := utils.linear_search_key(maze.tiles, Tile.Start) or_return
	to_check := make([dynamic]Candidate, 1)
	defer delete(to_check)
	to_check[0] = {
		node = {start_pos, .Right},
		cost = 0,
	}

	for len(to_check) > 0 {
		cur := pop_front(&to_check)
		next := [3]Candidate {
			{forward(cur.node), cur.cost + 1},
			{rotate_cw(cur.node), cur.cost + 1000},
			{rotate_ccw(cur.node), cur.cost + 1000},
		}
		for candidate in next {
			tile := maze.tiles[candidate.node.pos]
			if tile == .Wall do continue
			thingie, found := &graph[candidate.node]
			if found {
				if thingie.cost > candidate.cost {
					clear(&thingie.edges)
					append(&thingie.edges, cur.node)
					thingie.cost = candidate.cost
					append(&to_check, candidate)
				} else if thingie.cost == candidate.cost {
					append(&thingie.edges, cur.node)
				}
			} else {
				edges := make([dynamic]Node, 1)
				edges[0] = cur.node
				graph[candidate.node] = {candidate.cost, edges}
				append(&to_check, candidate)
			}
		}
	}

	min_cost := 99999999999
	end_node: Node
	for node, thingie in graph {
		tile := maze.tiles[node.pos]
		if tile == .End && thingie.cost < min_cost {
			min_cost = thingie.cost
			end_node = node
		}
	}

	visited := make(map[Vec2]bool)
	defer delete(visited)
	to_check2 := make([dynamic]Node, 1)
	defer delete(to_check2)
	to_check2[0] = end_node

	for len(to_check2) > 0 {
		node := pop_front(&to_check2)
		visited[node.pos] = true
		thingie := graph[node]
		for edge in thingie.edges {
			tile := maze.tiles[edge.pos]
			if tile != .Start do append(&to_check2, edge)
		}
	}
	result = len(visited) + 1

	return
}
