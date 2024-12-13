package main

import "../utils"
import "core:fmt"
import "core:math"
import "core:slice"

part1 :: proc(machines: []Machine) -> (result: int, err: any) {
	solutions := utils.map_ok(machines, solve)
	defer delete(solutions)

	for solution in solutions {
		result += int(3 * solution.x + solution.y)
	}

	return
}

solve :: proc(machine: Machine) -> (solution: Vec2, possible: bool) {
	using machine
	p := (prize.x * b.y - b.x * prize.y) / (b.y * a.x - b.x * a.y)
	q := (prize.y - a.y * p) / b.y

	if p >= 100 || q >= 100 || math.floor(p) != p || math.floor(q) != q do return solution, false
	else do return Vec2{p, q}, true
}
