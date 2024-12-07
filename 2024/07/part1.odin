package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

part1 :: proc(eqs: []Eq) -> (result: int, err: any) {
	valids := slice.filter(eqs, is_possible)
	for eq in valids {
		result += eq.value
	}
	return result, nil
}

is_possible :: proc(eq: Eq) -> bool {
	if len(eq.operands) == 1 do return eq.value == eq.operands[0]

	eq := eq
	a := eq.operands[0]
	b := eq.operands[1]
	sum := a + b
	product := a * b

	eq.operands = slice.concatenate([][]int{{sum}, eq.operands[2:]})
	defer delete(eq.operands)
	if is_possible(eq) do return true
	eq.operands[0] = product
	return is_possible(eq)
}
