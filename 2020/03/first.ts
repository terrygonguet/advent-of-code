export default function (input: string) {
	const rows = input.split("\n"),
		move = [3, 1],
		width = rows[0].length
	let pos = [0, 0],
		trees = 0

	do {
		const [x, y] = pos
		if (rows[y][x] == "#") trees++
		pos = [(x + move[0]) % width, y + move[1]]
	} while (pos[1] < rows.length)

	return trees
}
