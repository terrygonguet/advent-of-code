import { last } from "../tools.ts"

export default function (input: string) {
	const values = new Map<number, number[]>(),
		until = 30000000
	let lastSpoken = 0,
		turn = 1

	input
		.split(",")
		.map(n => parseInt(n))
		.forEach((n, i) => {
			values.set(n, [i + 1])
			lastSpoken = n
			turn++
		})

	do {
		const lastIndices = values.get(lastSpoken) ?? [0]
		if (lastIndices[0] == turn - 1) {
			set(values, 0, turn)
			lastSpoken = 0
		} else {
			let n = turn - lastIndices[0] - 1
			set(values, n, turn)
			lastSpoken = n
		}
		turn++
	} while (turn <= until)

	return lastSpoken
}

function set(values: Map<number, number[]>, k: number, v: number) {
	const n = values.get(k)
	if (!n) values.set(k, [v])
	else values.set(k, [last(n), v])
}
