import { last } from "../tools.ts"

export default function (input: string) {
	const values = input.split(",").map(n => parseInt(n))
	let lastSpoken = last(values)

	do {
		lastSpoken = last(values)
		let lastIndex = values.lastIndexOf(lastSpoken, values.length - 2)
		if (lastIndex == -1) {
			values.push(0)
		} else {
			values.push(values.length - 1 - lastIndex)
		}
	} while (values.length < 2020)

	return values[2019]
}
