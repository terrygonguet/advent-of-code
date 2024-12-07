package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part2 :: proc(lines: []string) -> (result: int, err: any) {
	for i in 1 ..< len(lines) - 1 {
		for j in 1 ..< len(lines[i]) - 1 {
			topLeft := lines[i - 1][j - 1]
			topRight := lines[i - 1][j + 1]
			botLeft := lines[i + 1][j - 1]
			botRight := lines[i + 1][j + 1]

			numM := 0
			numS := 0
			if topLeft == M do numM += 1
			else if topLeft == S do numS += 1
			if topRight == M do numM += 1
			else if topRight == S do numS += 1
			if botLeft == M do numM += 1
			else if botLeft == S do numS += 1
			if botRight == M do numM += 1
			else if botRight == S do numS += 1

			if numS == 2 && numM == 2 && lines[i][j] == A && topLeft != botRight do result += 1
		}
	}
	return
}
