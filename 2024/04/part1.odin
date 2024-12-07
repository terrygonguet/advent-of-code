package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

X :: 88
M :: 77
A :: 65
S :: 83

part1 :: proc(lines: []string) -> (result: int, err: any) {
	for line, i in lines {
		result += strings.count(line, "XMAS")
		result += strings.count(line, "SAMX")
		if i < len(lines) - 3 {
			// column
			for j in 0 ..< len(line) {
				if lines[i][j] == X && lines[i + 1][j] == M && lines[i + 2][j] == A && lines[i + 3][j] == S do result += 1
			}
			// diagonal \
			for j in 0 ..< len(line) - 3 {
				if lines[i][j] == X && lines[i + 1][j + 1] == M && lines[i + 2][j + 2] == A && lines[i + 3][j + 3] == S do result += 1
			}
			// diagonal /
			for j in 3 ..< len(line) {
				if lines[i][j] == X && lines[i + 1][j - 1] == M && lines[i + 2][j - 2] == A && lines[i + 3][j - 3] == S do result += 1
			}
		}
		if i >= 3 {
			// reverse column
			for j in 0 ..< len(line) {
				if lines[i][j] == X && lines[i - 1][j] == M && lines[i - 2][j] == A && lines[i - 3][j] == S do result += 1
			}
			// reverse diagonal \
			for j in 0 ..< len(line) - 3 {
				if lines[i][j] == X && lines[i - 1][j + 1] == M && lines[i - 2][j + 2] == A && lines[i - 3][j + 3] == S do result += 1
			}
			// reverse diagonal /
			for j in 3 ..< len(line) {
				if lines[i][j] == X && lines[i - 1][j - 1] == M && lines[i - 2][j - 2] == A && lines[i - 3][j - 3] == S do result += 1
			}
		}
	}
	return
}
