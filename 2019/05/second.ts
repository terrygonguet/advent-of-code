type IO = { in: number[]; out: number[] }
enum Mode {
	Position = "Position",
	Immediate = "Immediate",
}
type OpSet = [string, Mode, Mode, Mode]

const IO: IO = {
		in: [5],
		out: [],
	},
	debug = {
		clock: false,
		instruction: false,
		step: false,
	}

export default function (input: string) {
	const program = input.split(",").map(n => parseInt(n))
	return run(program)
}

function run(program: number[]) {
	let pc = 0,
		halt = false,
		clock = 0n
	if (debug.step) console.log(program)

	while (!halt) {
		if (debug.clock) console.log(`---- clock:${clock} - pc:${pc} ----`)

		const [instruction, modeA, modeB, modeC] = parseOpcode(program[pc]),
			addrA = program[pc + 1],
			addrB = program[pc + 2],
			addrC = program[pc + 3],
			a = modeA == Mode.Immediate ? addrA : program[addrA],
			b = modeB == Mode.Immediate ? addrB : program[addrB],
			c = modeC == Mode.Immediate ? addrC : program[addrC]

		switch (instruction) {
			case "01":
				if (debug.instruction) console.log("add", modeA, a, modeB, b, modeC, addrC)
				pc = add(program, pc, a, b, addrC)
				break
			case "02":
				if (debug.instruction) console.log("mult", modeA, a, modeB, b, modeC, addrC)
				pc = mult(program, pc, a, b, addrC)
				break
			case "03":
				if (debug.instruction) console.log(`input`, modeA, addrA)
				pc = input(program, pc, addrA)
				break
			case "04":
				if (debug.instruction) console.log("output", modeA, a)
				pc = output(program, pc, a)
				break
			case "05":
				if (debug.instruction) console.log("jumpIfTrue", modeA, a, modeB, b)
				pc = jumpIfTrue(program, pc, a, b)
				break
			case "06":
				if (debug.instruction) console.log("jumpIfFalse", modeA, a, modeB, b)
				pc = jumpIfFalse(program, pc, a, b)
				break
			case "07":
				if (debug.instruction) console.log("lessThan", modeA, a, modeB, b, modeC, addrC)
				pc = lessThan(program, pc, a, b, addrC)
				break
			case "08":
				if (debug.instruction) console.log("equals", modeA, a, modeB, b, modeC, addrC)
				pc = equals(program, pc, a, b, addrC)
				break
			case "99":
				if (debug.instruction) console.log("halt")
				halt = true
				break
			default:
				throw new Error(
					`Got unknown instuction "${instruction}" at position ${pc} (opcode: ${program[pc]}). PANIC!`,
				)
		}
		clock++
		if (debug.step) console.log(program)
		if (Object.values(debug).reduce((acc, cur) => acc || cur, false)) console.log()
	}

	return { result: program, IO, clock }
}

function parseOpcode(opcode: number): OpSet {
	const [a, b, c, d, e] = opcode.toString().padStart(5, "0")
	return [
		d + e,
		c == "0" ? Mode.Position : Mode.Immediate,
		b == "0" ? Mode.Position : Mode.Immediate,
		a == "0" ? Mode.Position : Mode.Immediate,
	]
}

function add(program: number[], pc: number, a: number, b: number, c: number) {
	program[c] = a + b
	return pc + 4
}

function mult(program: number[], pc: number, a: number, b: number, c: number) {
	program[c] = a * b
	return pc + 4
}

function input(program: number[], pc: number, a: number) {
	program[a] = IO.in.shift() ?? NaN
	return pc + 2
}

function output(program: number[], pc: number, a: number) {
	IO.out.push(a)
	return pc + 2
}

function jumpIfTrue(program: number[], pc: number, a: number, b: number) {
	return a ? b : pc + 3
}

function jumpIfFalse(program: number[], pc: number, a: number, b: number) {
	return !a ? b : pc + 3
}

function lessThan(program: number[], pc: number, a: number, b: number, c: number) {
	program[c] = a < b ? 1 : 0
	return pc + 4
}

function equals(program: number[], pc: number, a: number, b: number, c: number) {
	program[c] = a == b ? 1 : 0
	return pc + 4
}
