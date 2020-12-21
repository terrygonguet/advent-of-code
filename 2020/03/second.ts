type Position = [number, number]

export default function (input: string) {
	const rows = input.split("\n"),
		moves: Position[] = [
			[1, 1],
			[3, 1],
			[5, 1],
			[7, 1],
			[1, 2],
		]

	const trees = moves.map(move => howManyTreesWillIHit(rows, move))
	return trees.reduce((acc, cur) => acc * cur, 1)
}

function howManyTreesWillIHit(rows: string[], move: Position) {
	let pos = [0, 0],
		trees = 0,
		width = rows[0].length

	do {
		const [x, y] = pos
		if (rows[y][x] == "#") trees++
		pos = [(x + move[0]) % width, y + move[1]]
	} while (pos[1] < rows.length)

	return trees
}
