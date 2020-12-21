type IO = { in: number[]; out: number[] }
enum Mode {
	Position,
	Immediate,
}
type OpSet = [string, Mode, Mode, Mode]

const IO: IO = {
	in: [1],
	out: [],
}

export default function (input: string) {
	const program = input.split(",").map(n => parseInt(n))
	return run(program)
}

function run(program: number[]) {
	let pc = 0,
		halt = false,
		clock = 0n

	while (!halt) {
		// console.log(`---- ${clock} ----`)
		// console.log(pc, program)

		const [instruction, modeA, modeB, modeC] = parseOpcode(program[pc])
		switch (instruction) {
			case "01":
				pc = add(program, pc, modeA, modeB, modeC)
				break
			case "02":
				pc = mult(program, pc, modeA, modeB, modeC)
				break
			case "03":
				pc = inpt(program, pc, modeA)
				break
			case "04":
				pc = outpt(program, pc, modeA)
				break
			case "99":
				halt = true
				break
			default:
				throw new Error(
					`Got unknown instuction "${instruction}" at position ${pc} (opcode: ${program[pc]}). PANIC!`,
				)
		}
		clock++
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

function add(program: number[], pc: number, modeA: Mode, modeB: Mode, modeOut: Mode) {
	const addrInA = program[pc + 1],
		addrInB = program[pc + 2],
		addrOut = program[pc + 3],
		a = modeA == Mode.Immediate ? addrInA : program[addrInA],
		b = modeB == Mode.Immediate ? addrInB : program[addrInB]
	program[addrOut] = a + b
	return pc + 4
}

function mult(program: number[], pc: number, modeA: Mode, modeB: Mode, modeOut: Mode) {
	const addrInA = program[pc + 1],
		addrInB = program[pc + 2],
		addrOut = program[pc + 3],
		a = modeA == Mode.Immediate ? addrInA : program[addrInA],
		b = modeB == Mode.Immediate ? addrInB : program[addrInB]
	program[addrOut] = a * b
	return pc + 4
}

function inpt(program: number[], pc: number, modeIn: Mode) {
	const addrIn = program[pc + 1]
	program[addrIn] = IO.in.shift() ?? NaN
	return pc + 2
}

function outpt(program: number[], pc: number, modeOut: Mode) {
	const addrOut = program[pc + 1]
	IO.out.push(modeOut == Mode.Immediate ? addrOut : program[addrOut])
	return pc + 2
}
