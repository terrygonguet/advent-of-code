import { randomItem, wait } from "../tools.ts"

type IO = { in: bigint[]; out: bigint[] }
enum Mode {
	Position = "Position",
	Immediate = "Immediate",
	Relative = "Relative",
}
type OpSet = [string, Mode, Mode, Mode]
type Program = {
	pc: number
	halt: boolean
	clock: bigint
	base: number
	source: bigint[]
}

const IO: IO = {
		in: [],
		out: [],
	},
	debug = {
		clock: false,
		instruction: false,
		step: false,
		base: false,
	},
	w = 41,
	h = 41,
	map: number[][] = Array(h)
		.fill(0)
		.map(_ => Array(w).fill(0)),
	position = [Math.ceil(w / 2), Math.ceil(w / 2)]
let direction = 1,
	backtrack = false,
	goalPos = [0, 0]

map[position[1]][position[0]] = 1

function render() {
	console.clear()
	console.log("┏━" + "━━".repeat(w) + "━┓")
	for (let y = 0; y < map.length; y++) {
		let str = "",
			row = map[y]
		for (let x = 0; x < row.length; x++) {
			if (x == position[0] && y == position[1]) str += "[]"
			else str += code2tile(row[x])
		}
		console.log("┃ " + str + " ┃")
	}
	console.log("┗━" + "━━".repeat(w) + "━┛")
	console.log(`Direction: ${direction} - Backtrack: ${backtrack} - O2: ${goalPos}`)
}

function code2tile(code: number) {
	switch (code) {
		case -1:
			return "██"
		case 9999:
			return "!!"
		case 0:
			return "  "
		default:
			return code.toString(16).padStart(2, "0").slice(-2)
	}
}

export default async function (input: string) {
	let program: Program = {
		pc: 0,
		source: input.split(",").map(n => BigInt(n)),
		halt: false,
		clock: 0n,
		base: 0,
	}
	while (!program.halt) program = await run(program)

	return { result: program, in: IO.in.toString(), out: IO.out.toString() }
}

async function run(program: Program): Promise<Program> {
	let { base, clock, halt, pc, source } = program
	if (debug.step) console.log(source)

	function raw2in(raw: bigint, mode: Mode) {
		switch (mode) {
			case Mode.Position:
				return source[Number(raw)] ?? 0n
			case Mode.Immediate:
				return raw
			case Mode.Relative:
				return source[Number(raw) + base] ?? 0n
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

	if (debug.clock) console.log(`---- clock:${clock} - pc:${pc} ----`)

	const [instruction, modeA, modeB, modeC] = parseOpcode(source[pc]),
		rawA = source[pc + 1],
		rawB = source[pc + 2],
		rawC = source[pc + 3],
		inA = raw2in(rawA, modeA),
		inB = raw2in(rawB, modeB),
		// inC = raw2in(rawC, modeC),
		outA = raw2out(rawA, modeA),
		// outB = raw2out(rawB, modeB),
		outC = raw2out(rawC, modeC)

	switch (instruction) {
		case "01":
			if (debug.instruction) console.log("add", modeA, inA, modeB, inB, modeC, outC)
			pc = add(source, pc, inA, inB, outC)
			break
		case "02":
			if (debug.instruction) console.log("mult", modeA, inA, modeB, inB, modeC, outC)
			pc = mult(source, pc, inA, inB, outC)
			break
		case "03":
			if (debug.instruction) console.log(`input`, modeA, outA)
			pc = await input(source, pc, outA)
			break
		case "04":
			if (debug.instruction) console.log("output", modeA, inA)
			pc = output(source, pc, inA)
			break
		case "05":
			if (debug.instruction) console.log("jumpIfTrue", modeA, inA, modeB, inB)
			pc = jumpIfTrue(source, pc, inA, inB)
			break
		case "06":
			if (debug.instruction) console.log("jumpIfFalse", modeA, inA, modeB, inB)
			pc = jumpIfFalse(source, pc, inA, inB)
			break
		case "07":
			if (debug.instruction) console.log("lessThan", modeA, inA, modeB, inB, modeC, outC)
			pc = lessThan(source, pc, inA, inB, outC)
			break
		case "08":
			if (debug.instruction) console.log("equals", modeA, inA, modeB, inB, modeC, outC)
			pc = equals(source, pc, inA, inB, outC)
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
			throw new Error(`Got unknown instuction "${instruction}" at position ${pc} (opcode: ${source[pc]}). PANIC!`)
			clock++
			if (debug.step) console.log(program)
			if (Object.values(debug).reduce((acc, cur) => acc || cur, false)) console.log()
	}

	return { base, clock, halt, pc, source }
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

function add(source: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	source[c] = a + b
	return pc + 4
}

function mult(source: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	source[c] = a * b
	return pc + 4
}

async function input(source: bigint[], pc: number, a: number) {
	render()
	await wait(20)
	const [x, y] = position,
		current = map[y][x],
		neighbours = [north(position), south(position), west(position), east(position)]
	let found = false
	for (let i = 0; i < neighbours.length; i++) {
		if (neighbours[i] == 0) {
			direction = i + 1
			found = true
			break
		}
	}
	if (!found) {
		if (backtrack) {
			for (let i = 0; i < neighbours.length; i++) {
				if (neighbours[i] > 0 && neighbours[i] < current) {
					direction = i + 1
					found = true
					break
				}
			}
		} else {
			for (let i = 0; i < neighbours.length; i++) {
				if (neighbours[i] > current) {
					direction = i + 1
					found = true
					break
				}
			}
		}
	}
	if (!found) backtrack = !backtrack
	source[a] = BigInt(direction)
	return pc + 2
}

function output(source: bigint[], pc: number, a: bigint) {
	const [x, y] = position,
		current = map[y][x]
	if (a == 0n) {
		switch (direction) {
			case 1:
				map[y - 1][x] = -1
				break
			case 2:
				map[y + 1][x] = -1
				break
			case 3:
				map[y][x - 1] = -1
				break
			case 4:
				map[y][x + 1] = -1
				break
		}
	} else if (a >= 1n) {
		let next
		switch (direction) {
			case 1:
				next = map[y - 1][x]
				if (next == 0 || next > current + 1) map[y - 1][x] = current + 1
				position[1]--
				break
			case 2:
				next = map[y + 1][x]
				if (next == 0 || next > current + 1) map[y + 1][x] = current + 1
				position[1]++
				break
			case 3:
				next = map[y][x - 1]
				if (next == 0 || next > current + 1) map[y][x - 1] = current + 1
				position[0]--
				break
			case 4:
				next = map[y][x + 1]
				if (next == 0 || next > current + 1) map[y][x + 1] = current + 1
				position[0]++
				break
		}
		if (a == 2n) {
			map[position[1]][position[0]] = 9999
			goalPos = position.map(n => n)
		}
	}
	return pc + 2
}

function jumpIfTrue(source: bigint[], pc: number, a: bigint, b: bigint) {
	return a ? Number(b) : pc + 3
}

function jumpIfFalse(source: bigint[], pc: number, a: bigint, b: bigint) {
	return !a ? Number(b) : pc + 3
}

function lessThan(source: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	source[c] = a < b ? 1n : 0n
	return pc + 4
}

function equals(source: bigint[], pc: number, a: bigint, b: bigint, c: number) {
	source[c] = a == b ? 1n : 0n
	return pc + 4
}

function north(position: number[]) {
	return map[position[1] - 1][position[0]]
}

function south(position: number[]) {
	return map[position[1] + 1][position[0]]
}

function west(position: number[]) {
	return map[position[1]][position[0] - 1]
}

function east(position: number[]) {
	return map[position[1]][position[0] + 1]
}
