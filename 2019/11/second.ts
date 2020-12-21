type IO = { in: bigint[]; out: bigint[] }
enum Mode {
	Position = "Position",
	Immediate = "Immediate",
	Relative = "Relative",
}
type OpSet = [string, Mode, Mode, Mode]
enum Color {
	Black,
	White,
}
enum Direction {
	Up,
	Down,
	Left,
	Right,
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
	turtle = {
		hull: new Map<string, Color>(/* [["0 0", Color.White]] */),
		direction: Direction.Up,
		painting: true,
		x: 0,
		y: 0,
		minX: 0,
		maxX: 0,
		minY: 0,
		maxY: 0,
		get curColor() {
			return this.hull.get(this.x + " " + this.y) ?? Color.Black
		},
		paint(color: Color) {
			this.hull.set(this.x + " " + this.y, color)
			this.painting = false
		},
		turnLeft() {
			switch (this.direction) {
				case Direction.Up:
					this.direction = Direction.Left
					break
				case Direction.Down:
					this.direction = Direction.Right
					break
				case Direction.Left:
					this.direction = Direction.Down
					break
				case Direction.Right:
					this.direction = Direction.Up
					break
			}
		},
		turnRight() {
			switch (this.direction) {
				case Direction.Up:
					this.direction = Direction.Right
					break
				case Direction.Down:
					this.direction = Direction.Left
					break
				case Direction.Left:
					this.direction = Direction.Up
					break
				case Direction.Right:
					this.direction = Direction.Down
					break
			}
		},
		advance() {
			switch (this.direction) {
				case Direction.Up:
					this.y--
					this.minY = Math.min(this.minY, this.y)
					break
				case Direction.Down:
					this.y++
					this.maxY = Math.max(this.maxY, this.y)
					break
				case Direction.Left:
					this.x--
					this.minX = Math.min(this.minX, this.x)
					break
				case Direction.Right:
					this.x++
					this.maxX = Math.max(this.maxX, this.x)
					break
			}
			this.painting = true
		},
	}

export default function (input: string) {
	const program = input.split(",").map(n => BigInt(n))
	run(program)
	const width = turtle.maxX - turtle.minX + 1,
		height = turtle.maxY - turtle.minY + 1,
		grid = Array(height)
			.fill(0)
			.map(() => Array(width).fill(0))

	for (const [coords, color] of turtle.hull) {
		const [x, y] = coords.split(" ").map(n => parseInt(n))
		try {
			grid[y - turtle.minY][x - turtle.minX] = color
		} catch (error) {
			console.log(coords)
			console.error(error)
		}
	}

	return "\n" + grid.map(row => row.map(c => (c ? "██" : "  ")).join("")).join("\n")
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
	program[a] = BigInt(turtle.curColor)
	return pc + 2
}

function output(program: bigint[], pc: number, a: bigint) {
	if (turtle.painting) turtle.paint(a == 0n ? Color.Black : Color.White)
	else {
		if (a == 0n) turtle.turnLeft()
		else turtle.turnRight()
		turtle.advance()
	}
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
