package main

import "../utils"
import "core:fmt"
import "core:math"
import "core:slice"

part2 :: proc(elfputer: Elfputer) -> (result: int, err: any) {
	// elfputer := new_clone(elfputer)
	// defer free(elfputer)

	// out := slice.clone_to_dynamic(elfputer.program[:])
	// defer delete(out)

	// elfputer.a = 0
	// elfputer.pc = len(elfputer.program) - 2
	// for {
	// 	fmt.printfln("%#v\n%v", elfputer, out)
	// 	elfputer_unstep(elfputer, &out)
	// 	if elfputer.pc < 0 {
	// 		if len(out) == 0 do break
	// 		else do elfputer.pc = len(elfputer.program) - 2
	// 		break
	// 	}
	// }

	// result = int(elfputer.a)
	return
}

elfputer_unstep :: proc(elfputer: ^Elfputer, out: ^[dynamic]u8) {
	using elfputer
	instruction := Opcode(program[pc])
	operand := elfputer_resolve_operand(elfputer^, program[pc + 1], instruction_mode[instruction])

	switch instruction {
	case .ADV:
		elfputer.a <<= operand
	case .BXL:
		elfputer.b ~= operand
	case .BST:
		// HACK
		elfputer.a = ~u64(7) & elfputer.a + elfputer.b % 8
	case .JNZ:
	// noop
	case .BXC:
		elfputer.b ~= elfputer.c
	case .OUT:
		n := pop(out)
		elfputer.a = ~u64(7) & elfputer.a + u64(n)
	case .BDV:
		elfputer.b = elfputer.a << operand
	case .CDV:
		elfputer.c = elfputer.a << operand
	}
	elfputer.pc -= 2
}
