type Program = {
	source: Instruction[]
	pc: number
	accumulator: number
}

type Instruction = ["nop", number] | ["acc", number] | ["jmp", number]

export default async function (input: string) {
	let program = parse(input)

	for (let i = 0; i < program.source.length; i++) {
		const visited = new Set<number>()
		let candidate: Program = {
				...program,
				source: program.source.map(([op, val]) => [op, val]),
			},
			invalid = false
		const instruction = candidate.source[i]
		if (instruction[0] == "acc") continue
		instruction[0] = instruction[0] == "jmp" ? "nop" : "jmp"
		do {
			if (visited.has(candidate.pc) || candidate.pc > candidate.source.length || candidate.pc < 0) {
				invalid = true
				break
			}
			visited.add(candidate.pc)
			candidate = await run(candidate)
		} while (candidate.pc != candidate.source.length)
		if (!invalid) return candidate
	}
	throw new Error("Shouldn't happen")
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
