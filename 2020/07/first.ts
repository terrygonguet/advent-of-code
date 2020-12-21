type Dict = { [k: string]: number }

export default function (input: string) {
	const lines = input.split("\n"),
		bags = new Map<string, Dict>(lines.map(parseLine)),
		expanded = new Map<string, string[]>()
	let nbValid = 0
	for (let [color, dict] of bags) {
		let more: boolean
		do {
			;[dict, more] = expand(dict, bags)
		} while (more)
		const children = Object.keys(dict)
		expanded.set(color, children)
		if (children.includes("shiny gold")) nbValid++
	}

	return nbValid
}

function parseLine(line: string): [string, Dict] {
	const [container, children] = line
			.replace(".", "")
			.split("bags contain")
			.map(g => g.trim()),
		dict: Dict = {}
	if (children == "no other bags") return [container, {}]
	for (const child of children.split(",")) {
		const [n, color1, color2] = child.trim().split(" ")
		dict[color1 + " " + color2] = parseInt(n)
	}
	return [container, dict]
}

function expand(dict: Dict, map: Map<string, Dict>): [Dict, boolean] {
	let newDict = dict
	const nbKeys = Object.keys(dict).length
	for (const [key, val] of Object.entries(dict)) {
		const childDict = map.get(key) ?? {}
		newDict = {
			...newDict,
			...childDict,
		}
	}
	return [newDict, nbKeys != Object.keys(newDict).length]
}
