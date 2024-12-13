package main

import "../utils"
import "core:fmt"
import "core:math"
import "core:slice"

part2 :: proc(machines: []Machine) -> (result: int, err: any) {
	solutions := utils.map_ok(machines, solve_2)
	defer delete(solutions)

	for solution in solutions {
		result += int(3 * solution.x + solution.y)
	}

	return
}

solve_2 :: proc(machine: Machine) -> (solution: Vec2, possible: bool) {
	using machine
	big_prize := prize + 10000000000000
	p := (big_prize.x * b.y - b.x * big_prize.y) / (b.y * a.x - b.x * a.y)
	q := (big_prize.y - a.y * p) / b.y

	if math.floor(p) != p || math.floor(q) != q do return solution, false
	else do return Vec2{p, q}, true
}
