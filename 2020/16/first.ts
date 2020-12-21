export default function (input: string) {
	const [strRules, strMine, strNearby] = input.split("\n\n")
	const rules = parseRules(strRules)
	const nearby = parseTickets(strNearby)
	const [mine] = parseTickets(strMine)

	const validRange = new Set<number>()
	for (const rule of rules) {
		rule.values.forEach(n => validRange.add(n))
	}

	const errors = []
	for (const ticket of nearby) {
		errors.push(...ticket.filter(n => !validRange.has(n)))
	}

	return errors.reduce((acc, cur) => acc + cur)
}

function parseRules(str: string) {
	const lines = str.split("\n"),
		rules = []
	for (const line of lines) {
		const [name, ranges] = line.split(": ")
		const [rangeA, rangeB] = ranges.split(" or ")
		const rule = { name, values: new Set<number>() }
		const [rangeAstart, rangeAend] = rangeA.split("-").map(n => parseInt(n))
		const [rangeBstart, rangeBend] = rangeB.split("-").map(n => parseInt(n))
		for (let i = rangeAstart; i <= rangeAend; i++) {
			rule.values.add(i)
		}
		for (let i = rangeBstart; i <= rangeBend; i++) {
			rule.values.add(i)
		}
		rules.push(rule)
	}

	return rules
}

function parseTickets(str: string) {
	const [_, ...lines] = str.split("\n")
	return lines.map(l => l.split(",").map(n => parseInt(n)))
}
