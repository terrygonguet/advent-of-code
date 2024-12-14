package main

import "../utils"
import "core:fmt"
import "core:math/linalg"
import "core:slice"
import "core:time"

part2 :: proc(robots: []Robot, bounds: Vec2) -> (result: int, err: any) {

	for t := 0;; t += 1 {
		for &robot in robots {
			sim_robot(&robot, bounds)
		}
		var := pos_variance(robots, bounds)
		if var.x < 600 && var.y < 600 {
			result = t
			break
		}
	}

	return
}

pos_variance :: proc(robots: []Robot, bounds: Vec2) -> [2]f64 {
	sum := Vec2{0, 0}
	for robot in robots {
		sum += robot.pos
	}
	avg := sum / len(robots)
	square_sum := [2]f64{0, 0}
	for robot in robots {
		square_sum += linalg.pow(linalg.to_f64(robot.pos - avg), [2]f64{2, 2})
	}
	return square_sum / f64(len(robots) - 1)
}
