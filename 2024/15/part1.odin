package main

import "../utils"
import "core:fmt"
import "core:slice"

part1 :: proc(game: ^Sokoban) -> (result: int, err: any) {
	for move in game.moves {
		sokoban_move(game, move)
	}

	for pos, block in game.blocks {
		if block == .Box {
			result += pos.y * 100 + pos.x
		}
	}

	return
}

sokoban_move :: proc(game: ^Sokoban, move: Direction) -> (ok: bool) {
	pos := utils.linear_search_key(game.blocks, Block.Robot) or_return
	sokoban_can_move(game^, pos, move) or_return
	return sokoban_apply_move(game, pos, move)
}

sokoban_can_move :: proc(game: Sokoban, pos: Vec2, move: Direction) -> bool {
	target_pos := pos + step[move]
	switch game.blocks[target_pos] {
	case .Empty:
		return true
	case .Wall:
		return false
	case .Robot:
		return false
	case .Box:
		return sokoban_can_move(game, target_pos, move)
	case .BoxL:
		switch move {
		case .Up:
			fallthrough
		case .Down:
			return(
				sokoban_can_move(game, target_pos, move) &&
				sokoban_can_move(game, target_pos + right, move) \
			)
		case .Left:
			return sokoban_can_move(game, target_pos, move)
		case .Right:
			return sokoban_can_move(game, target_pos + right, move)
		}
	case .BoxR:
		switch move {
		case .Up:
			fallthrough
		case .Down:
			return(
				sokoban_can_move(game, target_pos, move) &&
				sokoban_can_move(game, target_pos + left, move) \
			)
		case .Left:
			return sokoban_can_move(game, target_pos + left, move)
		case .Right:
			return sokoban_can_move(game, target_pos, move)
		}
	}
	return false
}

sokoban_apply_move :: proc(game: ^Sokoban, pos: Vec2, move: Direction) -> (ok: bool) {
	target_pos := pos + step[move]
	#partial switch game.blocks[target_pos] {
	case .Wall:
		return false
	case .Box:
		sokoban_apply_move(game, target_pos, move) or_return
	case .BoxL:
		if move == .Up || move == .Down {
			sokoban_apply_move(game, target_pos, move) or_return
			sokoban_apply_move(game, target_pos + right, move) or_return
		} else {
			sokoban_apply_move(game, target_pos, move) or_return
		}
	case .BoxR:
		if move == .Up || move == .Down {
			sokoban_apply_move(game, target_pos, move) or_return
			sokoban_apply_move(game, target_pos + left, move) or_return
		} else {
			sokoban_apply_move(game, target_pos, move) or_return
		}
	}
	temp := game.blocks[pos]
	game.blocks[pos] = game.blocks[target_pos]
	game.blocks[target_pos] = temp
	return true
}
