export default function (input: string) {
	const lines = input.split("\n")
	let total = 0

	for (const line of lines) {
		const [rule, password] = line.split(":").map(a => a.trim())
		const test = compile(rule)
		total += Number(test(password))
	}

	return total
}

function compile(rule: string) {
	if (!/^\d\d?-\d\d?\s\w/.test(rule)) throw new Error(`Invalid password rule: ${rule}`)

	const [range, letter] = rule.split(" ")
	const [i, j] = range.split("-").map(a => parseInt(a))

	return function test(password: string) {
		const first = password[i - 1],
			second = password[j - 1]
		return (first == letter) !== (second == letter)
	}
}
