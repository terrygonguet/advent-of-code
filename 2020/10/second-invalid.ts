// Theoritically right but overflows memory very fast cause naive implementation

export default function (input: string) {
	const adapters = input
			.split("\n")
			.map(x => parseInt(x))
			.sort((a, b) => a - b),
		tree = new Tree(0)
	for (let i = 0; i < adapters.length; i++) {
		console.log(Math.ceil((i / adapters.length) * 100) + "%")
		tree.add(adapters[i])
	}
	return tree.numLeaves
}

class Tree {
	branches: Tree[] = []
	value: number

	constructor(val: number) {
		this.value = val
	}

	add(val: number) {
		if (val <= this.value) return
		this.branches.forEach(t => t.add(val))
		if (val <= this.value + 3) this.branches.push(new Tree(val))
	}

	get numLeaves(): number {
		return this.branches.map(t => t.numLeaves).reduce((acc, cur) => acc + cur, 0) || 1
	}
}
