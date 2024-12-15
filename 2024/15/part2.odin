package main

import "../utils"
import "core:fmt"
import "core:slice"

part2 :: proc(game: ^Sokoban) -> (result: int, err: any) {
	for move, i in game.moves {
		sokoban_move(game, move)
	}

	for pos, block in game.blocks {
		if block == .BoxL {
			result += pos.y * 100 + pos.x
		}
	}

	return
}
