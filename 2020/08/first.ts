type Program = {
	source: Instruction[]
	pc: number
	accumulator: number
}

type Instruction = ["nop", number] | ["acc", number] | ["jmp", number]

export default async function (input: string) {
	let program = parse(input)
	const visited = new Set<number>()
	do {
		if (visited.has(program.pc)) break
		visited.add(program.pc)
		program = await run(program)
	} while (true)

	return program
}

function parse(input: string): Program {
	const source = input.split("\n").map<Instruction>(line => {
		const [op, val] = line.split(" ")
		return [op, parseInt(val)] as Instruction
	})
	return { source, pc: 0, accumulator: 0 }
}

async function run(program: Program): Promise<Program> {
	let { source, pc, accumulator } = program
	const instruction = source[pc]
	switch (instruction[0]) {
		case "acc":
			accumulator += instruction[1]
			pc++
			break
		case "jmp":
			pc += instruction[1]
			break
		case "nop":
			pc++
			break
		default:
			throw new Error(`Unknown operation "${instruction[0]}" with value ${instruction[1]} at ${pc}`)
	}
	return { source, pc, accumulator }
}
