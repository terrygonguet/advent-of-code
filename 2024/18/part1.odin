package main

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

	path, found := a_star_pathfind(blocked, bounds, {0, 0}, bounds - {1, 1})
	assert(found, "Can't find a path")
	defer delete(path)

	// for y in 0 ..< bounds.y {
	// 	for x in 0 ..< bounds.x {
	// 		pos := Vec2{x, y}
	// 		_, is_in_path := slice.linear_search(path, pos)
	// 		if blocked[pos] do fmt.print("#")
	// 		else if is_in_path do fmt.print("O")
	// 		else do fmt.print(".")
	// 	}
	// 	fmt.println()
	// }
	// fmt.println()

	result = len(path) - 1

	return
}

Node :: struct {
	cost:      int,
	heuristic: int,
	position:  Vec2,
	parent:    Vec2,
}

up :: Vec2{0, -1}
down :: Vec2{0, 1}
left :: Vec2{-1, 0}
right :: Vec2{1, 0}

a_star_pathfind :: proc(
	blocked: map[Vec2]bool,
	bounds, start, end: Vec2,
) -> (
	path: []Vec2,
	found: bool,
) {
	visited := make(map[Vec2]Node)
	defer delete(visited)

	to_check := make([dynamic]Node, 1)
	defer delete(to_check)
	to_check[0] = a_star_node(0, start, start, end)

	for len(to_check) > 0 {
		node := pop(&to_check)
		using node
		visited[position] = node

		if node.position == end do break

		neighbours := [4]Vec2{position + up, position + down, position + left, position + right}
		for neighbour in neighbours {
			if (neighbour.x < 0 ||
				   neighbour.x >= bounds.x ||
				   neighbour.y < 0 ||
				   neighbour.y >= bounds.y ||
				   blocked[neighbour] ||
				   neighbour in visited) {continue}

			cur_node := a_star_node(cost + 1, neighbour, position, end)
			idx, found := slice.binary_search_by(to_check[:], cur_node, a_star_node_compare)
			if !found do inject_at(&to_check, idx, cur_node)
			else if to_check[idx].cost > cur_node.cost {
				to_check[idx].cost = cur_node.cost
				to_check[idx].parent = position
			}
		}
	}

	found = end in visited
	if !found do return

	cur_node := visited[end]
	path = make([]Vec2, cur_node.cost + 1)
	for i := len(path) - 1; i >= 0; i -= 1 {
		path[i] = cur_node.position
		cur_node = visited[cur_node.parent]
	}

	return
}

a_star_node :: proc(cost: int, position, parent, end: Vec2) -> Node {
	delta := end - position
	return {
		cost = cost,
		heuristic = abs(delta.x) + abs(delta.y),
		position = position,
		parent = parent,
	}
}

// Inverted to avoid having to do a full copy of `to_check`
a_star_node_compare :: proc(a, b: Node) -> slice.Ordering {
	if a == b || a.position == b.position do return .Equal
	delta := b.cost + b.heuristic - a.cost - a.heuristic
	switch {
	case delta < 0:
		return .Less
	case delta > 0:
		return .Greater
	}
	return .Greater
}
