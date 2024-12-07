package main

import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"

part2 :: proc(eqs: []Eq) -> (result: int, err: any) {
	valids := slice.filter(eqs, is_possible_2)
	for eq in valids {
		result += eq.value
	}
	return result, nil
}

concat :: proc(a, b: int) -> int {
	// if b == 0 do return a * 10
	// if b == 1 do return a * 10 + 1
	// f := math.pow10(math.ceil(math.log10(cast(f64)b)))
	// return a * cast(int)f + b
	buf1: [16]byte
	buf2: [16]byte
	result := strings.concatenate({strconv.itoa(buf1[:], a), strconv.itoa(buf2[:], b)})
	return strconv.atoi(result)
}

is_possible_2 :: proc(eq: Eq) -> bool {
	if len(eq.operands) == 1 do return eq.value == eq.operands[0]

	eq := eq
	a := eq.operands[0]
	b := eq.operands[1]
	sum := a + b

	eq.operands = slice.concatenate([][]int{{sum}, eq.operands[2:]})
	defer delete(eq.operands)
	if is_possible_2(eq) do return true

	product := a * b
	eq.operands[0] = product
	if is_possible_2(eq) do return true

	horror := concat(a, b)
	eq.operands[0] = horror
	return is_possible_2(eq)
}
