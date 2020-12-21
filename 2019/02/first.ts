export default function (input: string) {
	const program = input.split(",").map(n => parseInt(n))
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
