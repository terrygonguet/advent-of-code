export default function (input: string) {
	const lines = input.split("\n"),
		bags = new Map(lines.map(parseLine)),
		shinyGold = bags.get("shiny gold")

	return shinyGold?.flatMap(function expand(bag): string[] {
		return [bag, ...(bags.get(bag)?.flatMap(expand) ?? [])]
	}).length
}

function parseLine(line: string): [string, string[]] {
	const [container, children] = line
			.replace(".", "")
			.split("bags contain")
			.map(g => g.trim()),
		inner = Array<string>()
	if (children == "no other bags") return [container, []]
	for (const child of children.split(",")) {
		const [n, color1, color2] = child.trim().split(" ")
		inner.push(...Array(parseInt(n)).fill(color1 + " " + color2))
	}
	return [container, inner]
}
