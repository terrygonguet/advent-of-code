package main

import "../utils"
import "core:fmt"
import "core:slice"

part1 :: proc(robots: []Robot, bounds: Vec2) -> (result: int, err: any) {
	for t in 0 ..< 100 {
		for &robot in robots {
			sim_robot(&robot, bounds)
		}
	}

	quadrants := matrix[2, 2]int{
		0, 0, 
		0, 0, 
	}
	v := bounds.x / 2
	h := bounds.y / 2
	for robot in robots {
		if robot.pos.x == v || robot.pos.y == h do continue
		x := 0 if robot.pos.x < v else 1
		y := 0 if robot.pos.y < h else 1
		quadrants[x, y] += 1
	}
	result = quadrants[0, 0] * quadrants[0, 1] * quadrants[1, 0] * quadrants[1, 1]

	return
}

sim_robot :: proc(robot: ^Robot, bounds: Vec2) {
	robot.pos += robot.vel
	robot.pos %%= bounds
}

debug :: proc(robots: []Robot, bounds: Vec2) {
	for y in 0 ..< bounds.y {
		for x in 0 ..< bounds.x {
			pos := Vec2{x, y}
			num_robots := utils.reduce_ctx(
				robots,
				pos,
				0,
				proc(sum: int, robot: Robot, pos: Vec2) -> int {
					return sum + (1 if robot.pos == pos else 0)
				},
			)
			if num_robots == 0 do fmt.print(".")
			else do fmt.print(num_robots)
		}
		fmt.print("\n")
	}
}
