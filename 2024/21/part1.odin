package main

import "../utils"
import "core:fmt"
import "core:slice"
import "core:strconv"

part1 :: proc(codes: []string) -> (result: int, err: any) {
	codes := []string{"379A"}
	for code in codes {
		code_val := strconv.atoi(code)
		num_moves := 0

		robot1 := 'A'
		robot2 := DirKeypress.Accept
		robot3 := DirKeypress.Accept
		for char in code {
			path := num_keypad_path(robot1, char)
			robot1 = char
			robot1_moves := path_to_keypresses(robot2, path)
			defer delete(robot1_moves)

			for move in robot1_moves {
				path := dir_keypad_path(robot2, move)
				robot2 = move
				robot2_moves := path_to_keypresses(robot3, path)
				defer delete(robot2_moves)

				for move in robot2_moves {
					path := dir_keypad_path(robot3, move)
					robot3 = move
					robot3_moves := path_to_keypresses(robot3, path)
					defer delete(robot3_moves)

					num_moves += len(robot3_moves)
				}
			}
		}

		fmt.println(code, "=>", num_moves, "*", code_val)
		result += num_moves * code_val
	}

	return
}

Path :: struct {
	start1: DirKeypress,
	start2: union {
		DirKeypress,
	},
	delta:  Vec2,
}

num_keypad_path :: proc(start, end: rune) -> Path {
	pos_start := num_keypad[start]
	pos_end := num_keypad[end]
	delta := pos_end - pos_start
	dist := abs(delta.x) + abs(delta.y)

	path := Path {
		delta = delta,
	}
	if start == '0' && end == 'A' do path.start1 = .Right
	else if start == 'A' && end == '0' do path.start1 = .Left
	else if pos_start.y == 3 && pos_end.x == 0 do path.start1 = .Up
	else if pos_start.x == 0 && pos_end.y == 3 do path.start1 = .Right
	else if delta.x == 0 do path.start1 = .Up if delta.y < 0 else .Down
	else if delta.y == 0 do path.start1 = .Left if delta.x < 0 else .Right
	else {
		path.start1 = .Up if delta.y < 0 else .Down
		path.start2 = .Left if delta.x < 0 else .Right
	}

	return path
}

dir_keypad_path :: proc(start, end: DirKeypress) -> Path {
	pos_start := dir_keypad[start]
	pos_end := dir_keypad[end]
	delta := pos_end - pos_start
	dist := abs(delta.x) + abs(delta.y)

	path := Path {
		delta = delta,
	}
	if start == .Up && end == .Accept do path.start1 = .Right
	else if start == .Accept && end == .Up do path.start1 = .Left
	else if pos_start.y == 0 && pos_end.x == 0 do path.start1 = .Down
	else if pos_start.x == 0 && pos_end.y == 0 do path.start1 = .Right
	else if delta.x == 0 do path.start1 = .Up if delta.y < 0 else .Down
	else if delta.y == 0 do path.start1 = .Left if delta.x < 0 else .Right
	else {
		path.start1 = .Up if delta.y < 0 else .Down
		path.start2 = .Left if delta.x < 0 else .Right
	}

	return path
}

dir_keypad_dist :: proc(start, end: DirKeypress) -> int {
	return vec2_dist(dir_keypad[start], dir_keypad[end])
}

path_to_keypresses :: proc(robot: DirKeypress, path: Path) -> []DirKeypress {
	presses: [dynamic]DirKeypress

	first_press := path.start1
	start2, has_start2 := path.start2.(DirKeypress)
	if has_start2 {
		dist1 := dir_keypad_dist(robot, first_press)
		dist2 := dir_keypad_dist(robot, start2)
		if dist2 < dist1 do first_press = start2
	}

	first_horizontal := first_press == .Left || first_press == .Right
	for i in 0 ..< abs(path.delta.x if first_horizontal else path.delta.y) {
		append(&presses, first_press)
	}
	second_delta := path.delta.y if first_horizontal else path.delta.x
	second_press: DirKeypress
	if first_horizontal {
		second_press = DirKeypress.Up if second_delta < 0 else DirKeypress.Down
	} else {
		second_press = DirKeypress.Left if second_delta < 0 else DirKeypress.Right
	}
	for i in 0 ..< abs(second_delta) {
		append(&presses, second_press)
	}

	append(&presses, DirKeypress.Accept)

	return presses[:]
}
