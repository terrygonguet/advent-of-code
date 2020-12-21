type Rule = {
	name: string
	values: Set<number>
}

export default function (input: string) {
	const [strRules, strMine, strNearby] = input.split("\n\n")
	const rules = parseRules(strRules)
	const nearby = parseTickets(strNearby)
	const [mine] = parseTickets(strMine)

	const validRange = new Set<number>()
	for (const rule of rules) {
		rule.values.forEach(n => validRange.add(n))
	}
	const validNearby = nearby.filter(ticket => {
		for (const value of ticket) {
			if (!validRange.has(value)) return false
		}
		return true
	})

	const rulesMap = new Map<number, Rule[]>()
	for (const rule of rules) {
		for (let i = 0; i < rules.length; i++) {
			let isValid = true
			for (const ticket of validNearby) {
				if (!rule.values.has(ticket[i])) {
					isValid = false
					break
				}
			}
			if (isValid) {
				rulesMap.set(i, [rule, ...(rulesMap.get(i) ?? [])])
			}
		}
	}
	const orderedRules = []
	let done
	do {
		done = true
		for (const [i, rules] of rulesMap) {
			if (rules.length == 1) {
				orderedRules[i] = rules[0]
				rulesMap.forEach(
					(v, k) =>
						k != i &&
						rulesMap.set(
							k,
							v.filter(r => r != rules[0]),
						),
				)
			} else done = false
		}
	} while (!done)

	const orderedTicket = orderedRules.map((rule, i) => (rule.name.startsWith("departure") ? mine[i] : 1))

	return orderedTicket.reduce((acc, cur) => acc * cur, 1)
}

function parseRules(str: string): Rule[] {
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
