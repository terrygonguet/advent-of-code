package pathfinding

import "core:fmt"
import "core:slice"

@(private)
Vec2 :: [2]int

@(private)
Node :: struct {
	cost:      int,
	heuristic: int,
	position:  Vec2,
	parent:    Vec2,
}

@(private)
up :: Vec2{0, -1}
@(private)
down :: Vec2{0, 1}
@(private)
left :: Vec2{-1, 0}
@(private)
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
				   blocked[position] ||
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

@(private)
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

maze_debug :: proc(blocked: map[Vec2]bool, path: []Vec2, bounds, start, end: Vec2) {
	for y in 0 ..< bounds.y {
		for x in 0 ..< bounds.x {
			pos := Vec2{x, y}
			switch {
			case pos == start:
				fmt.print("S")
			case pos == end:
				fmt.print("E")
			case blocked[pos]:
				fmt.print("#")
			case:
				if _, found := slice.linear_search(path, pos); found do fmt.print("O")
				else do fmt.print(".")
			}
		}
		fmt.println()
	}
}
