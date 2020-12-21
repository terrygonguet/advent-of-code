export default function (input: string) {
	const groups = input.split("\n\n")
	return groups.map(group2nbyes).reduce((acc, cur) => acc + cur, 0)
}

function group2nbyes(group: string) {
	const people = group.split("\n"),
		letters = new Set<string>()
	for (const person of people) {
		Array.from(person).forEach(l => letters.add(l))
	}
	return letters.size
}
