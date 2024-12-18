package main

import "../utils"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	when ODIN_DEBUG {
		tracking := utils.tracking_init()
		context.allocator = mem.tracking_allocator(&tracking)
		defer utils.tracking_cleanup(&tracking)
	}

	puzzle, err := utils.get_puzzle()
	defer delete(puzzle)
	lines := strings.split(puzzle, "\n")
	defer delete(lines)
	assert(err == nil, "Failed to read puzzle input")
	assert(len(lines) > 0, "Puzzle input is empty")

	elfputer, parse_ok := elfputer_parse(puzzle)
	defer elfputer_destroy(elfputer)

	if res1, err1 := part1(elfputer); err == nil {
		fmt.print("Part 1:  ")
		for n in res1 {
			fmt.print(n)
			fmt.print(",")
		}
		fmt.print("\n")
		delete(res1)
	} else {
		fmt.println("Part 1 error'd: ", err1)
	}
	if res2, err2 := part2(elfputer); err == nil {
		fmt.println("Part 2: ", res2)
	} else {
		fmt.println("Part 2 error'd: ", err2)
	}
}

Elfputer :: struct {
	a:       u64,
	b:       u64,
	c:       u64,
	pc:      int,
	program: [dynamic]u8,
}

elfputer_parse :: proc(str: string) -> (elfputer: Elfputer, ok: bool) {
	lines := strings.split_lines(str)
	defer delete(lines)

	if len(lines) != 5 do return
	strings.starts_with(lines[0], "Register A: ") or_return
	strings.starts_with(lines[1], "Register B: ") or_return
	strings.starts_with(lines[2], "Register C: ") or_return
	strings.starts_with(lines[4], "Program: ") or_return

	elfputer.a = u64(strconv.atoi(lines[0][12:]))
	elfputer.b = u64(strconv.atoi(lines[1][12:]))
	elfputer.c = u64(strconv.atoi(lines[2][12:]))

	program_str := lines[4][9:]
	for n in strings.split_iterator(&program_str, ",") {
		append(&elfputer.program, u8(strconv.atoi(n)))
	}

	ok = true
	return
}

elfputer_destroy :: proc(elfputer: Elfputer) {
	delete(elfputer.program)
}

Opcode :: enum {
	ADV,
	BXL,
	BST,
	JNZ,
	BXC,
	OUT,
	BDV,
	CDV,
}

OperandMode :: enum {
	Literal,
	Combo,
}

instruction_mode := [Opcode]OperandMode {
	.ADV = .Combo,
	.BXL = .Literal,
	.BST = .Combo,
	.JNZ = .Literal,
	.BXC = .Literal,
	.OUT = .Combo,
	.BDV = .Combo,
	.CDV = .Combo,
}

elfputer_resolve_operand :: proc(elfputer: Elfputer, operand: u8, mode: OperandMode) -> u64 {
	switch mode {
	case .Literal:
		return u64(operand)
	case .Combo:
		switch operand {
		case 0:
			fallthrough
		case 1:
			fallthrough
		case 2:
			fallthrough
		case 3:
			return u64(operand)
		case 4:
			return elfputer.a
		case 5:
			return elfputer.b
		case 6:
			return elfputer.c
		case 7:
			panic("Tried to resolve the operand 7 in Combo mode")
		}
	}
	panic(fmt.tprintf("Unhandled resolve: operand %d, mode: %v", operand, mode))
}
