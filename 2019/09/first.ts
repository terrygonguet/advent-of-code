type IO = { in: bigint[]; out: bigint[] }
enum Mode {
	Position = "Position",
	Immediate = "Immediate",
	Relative = "Relative",
}
type OpSet = [string, Mode, Mode, Mode]

const IO: IO = {
		in: [1n],
		out: [],
	},
	debug = {
		clock: false,
		instruction: true,
		step: false,
		base: true,
	}

export default function (input: string) {
	const program = input.split(",").map(n => BigInt(n))
	return run(program)
}

function run(program: bigint[]) {
	let pc = 0,
		halt = false,
		clock = 0n,
		base = 0
	if (debug.step) console.log(program)

	function raw2in(raw: bigint, mode: Mode) {
		switch (mode) {
			case Mode.Position:
				return program[Number(raw)] ?? 0n
			case Mode.Immediate:
				return raw
			case Mode.Relative:
				return program[Number(raw) + base] ?? 0n
		}
	}

	function raw2out(raw: bigint, mode: Mode) {
		switch (mode) {
			case Mode.Position:
				return Number(raw)
			case Mode.Immediate:
				return NaN
			case Mode.Relative:
				return Number(raw) + base
		}
	}

	while (!halt) {
		if (debug.clock) console.log(`---- clock:${clock} - pc:${pc} ----`)

		const [instruction, modeA, modeB, modeC] = parseOpcode(program[pc]),
			rawA = program[pc + 1],
			rawB = program[pc + 2],
			rawC = program[pc + 3],
			inA = raw2in(rawA, modeA),
			inB = raw2in(rawB, modeB),
			// inC = raw2in(rawC, modeC),
			outA = raw2out(rawA, modeA),
			// outB = raw2out(rawB, modeB),
			outC = raw2out(rawC, modeC)

		switch (instruction) {
			case "01":
				if (debug.instruction) console.log("add", modeA, inA, modeB, inB, modeC, outC)
				pc = add(program, pc, inA, inB, outC)
				break
			case "02":
				if (debug.instruction) console.log("mult", modeA, inA, modeB, inB, modeC, outC)
				pc = mult(program, pc, inA, inB, outC)
				break
			case "03":
				if (debug.instruction) console.log(`input`, modeA, outA)
				pc = input(program, pc, outA)
				break
			case "04":
				if (debug.instruction) console.log("output", modeA, inA)
				pc = output(program, pc, inA)
				break
			case "05":
				if (debug.instruction) console.log("jumpIfTrue", modeA, inA, modeB, inB)
				pc = jumpIfTrue(program, pc, inA, inB)
				break
			case "06":
				if (debug.instruction) console.log("jumpIfFalse", modeA, inA, modeB, inB)
				pc = jumpIfFalse(program, pc, inA, inB)
				break
			case "07":
				if (debug.instruction) console.log("lessThan", modeA, inA, modeB, inB, modeC, outC)
				pc = lessThan(program, pc, inA, inB, outC)
				break
			case "08":
				if (debug.instruction) console.log("equals", modeA, inA, modeB, inB, modeC, outC)
				pc = equals(program, pc, inA, inB, outC)
				break
			case "09":
				if (debug.instruction) console.log("setRelativeBase", modeA, inA)
				if (debug.base) console.log(`Set base from ${base} to ${base + Number(inA)}`)
				// inlined to use `base`
				base += Number(inA)
				pc += 2
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

	return { result: program, in: IO.in.toString(), out: IO.out.toString(), clock }
}

function parseOpcode(opcode: bigint): OpSet {
	const [a, b, c, d, e] = opcode.toString().padStart(5, "0"),
		modes: { [k: string]: Mode } = {
			0: Mode.Position,
			1: Mode.Immediate,
			2: Mode.Relative,
		}
	return [d + e, modes[c], modes[b], modes[a]]
}

function add(program: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	program[c] = a + b
	return pc + 4
}

function mult(program: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	program[c] = a * b
	return pc + 4
}

function input(program: bigint[], pc: number, a: number) {
	program[a] = IO.in.shift() ?? 0n
	return pc + 2
}

function output(program: bigint[], pc: number, a: bigint) {
	IO.out.push(a)
	return pc + 2
}

function jumpIfTrue(program: bigint[], pc: number, a: bigint, b: bigint) {
	return a ? Number(b) : pc + 3
}

function jumpIfFalse(program: bigint[], pc: number, a: bigint, b: bigint) {
	return !a ? Number(b) : pc + 3
}

function lessThan(program: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	program[c] = a < b ? 1n : 0n
	return pc + 4
}

function equals(program: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	program[c] = a == b ? 1n : 0n
	return pc + 4
}
