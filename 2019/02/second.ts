export default function (input: string) {
	for (let i = 0; i <= 99; i++) {
		for (let j = 0; j <= 99; j++) {
			const program = input.split(",").map(n => parseInt(n))
			program[1] = i
			program[2] = j
			const result = run(program)
			if (result[0] == 19690720) return 100 * i + j
		}
	}
}

function run(program: number[]) {
	let pc = 0,
		halt = false,
		clock = BigInt(0)

	while (!halt) {
		// console.log(`---- ${clock} ----`)
		// console.log(pc, program)

		const opcode = program[pc]
		switch (opcode) {
			case 1:
				pc = add(program, pc)
				break
			case 2:
				pc = mult(program, pc)
				break
			case 99:
				halt = true
				break
			default:
				throw new Error(`Got unknown opcode "${opcode}" at position ${pc}. PANIC!`)
		}
		clock++
	}

	return program
}

function add(program: number[], pc: number) {
	const addrInA = program[pc + 1],
		addrInB = program[pc + 2],
		addrOut = program[pc + 3],
		a = program[addrInA],
		b = program[addrInB]
	program[addrOut] = a + b
	return pc + 4
}

function mult(program: number[], pc: number) {
	const addrInA = program[pc + 1],
		addrInB = program[pc + 2],
		addrOut = program[pc + 3],
		a = program[addrInA],
		b = program[addrInB]
	program[addrOut] = a * b
	return pc + 4
}
