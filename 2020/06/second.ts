export default function (input: string) {
	const groups = input.split("\n\n")
	return groups.map(group2nbyes).reduce((acc, cur) => acc + cur, 0)
}

function group2nbyes(group: string) {
	const people = group.split("\n"),
		letters = new Map<string, number>()
	for (const person of people) {
		Array.from(person).forEach(l => letters.set(l, (letters.get(l) ?? 0) + 1))
	}
	let total = 0
	for (const [letter, n] of letters.entries()) {
		if (n == people.length) total++
	}
	return total
}
