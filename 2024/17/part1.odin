package main

import "../utils"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"

part1 :: proc(elfputer: Elfputer) -> (result: [dynamic]u8, err: any) {
	elfputer := new_clone(elfputer)
	defer free(elfputer)

	for halt := false; !halt; halt = elfputer_step(elfputer, &result) {}

	return
}

elfputer_step :: proc(elfputer: ^Elfputer, out: ^[dynamic]u8) -> (halted: bool) {
	using elfputer
	instruction := Opcode(program[pc])
	operand := elfputer_resolve_operand(elfputer^, program[pc + 1], instruction_mode[instruction])

	switch instruction {
	case .ADV:
		elfputer.a = u64(f64(elfputer.a) / math.pow2_f64(operand))
	case .BXL:
		elfputer.b ~= operand
	case .BST:
		elfputer.b = operand % 8
	case .JNZ:
		if elfputer.a != 0 do elfputer.pc = int(operand - 2)
	case .BXC:
		elfputer.b ~= elfputer.c
	case .OUT:
		append(out, u8(operand % 8))
	case .BDV:
		elfputer.b = u64(f64(elfputer.a) / math.pow2_f64(operand))
	case .CDV:
		elfputer.c = u64(f64(elfputer.a) / math.pow2_f64(operand))
	}
	elfputer.pc += 2

	return int(pc) >= len(program)
}
