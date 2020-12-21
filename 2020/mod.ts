type Solver = (input: string) => void
type SolverModule = { default: Solver }

const [day, stage = "first", test = false] = Deno.args

async function run(day: string, stage: string) {
	const { default: fn }: SolverModule = await import(`./${day}/${stage}.ts`)
	const decoder = new TextDecoder("utf-8")
	const data = await Deno.readFile(test ? `./${day}/input-${test}` : `./${day}/input`)
	console.time(stage)
	const solution = await Promise.resolve(fn(decoder.decode(data)))
	console.log(`Solution:`, solution)
	console.timeEnd(stage)
}

run(day, stage)

export default {}
