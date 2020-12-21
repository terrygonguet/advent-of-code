type Pair = [number, number]

export default function (input: string) {
	const passes = input.split("\n"),
		ids = passes.map(getPassID)
	return ids.reduce((acc, cur) => Math.max(acc, cur), -Infinity)
}

function getPassID(pass: string) {
	const rows = pass.slice(0, 7),
		cols = pass.slice(7)
	let row: Pair = [0, 127],
		col: Pair = [0, 7]

	for (let i = 0; i < rows.length; i++) {
		const step = 128 / Math.pow(2, i + 1),
			letter = rows[i]
		if (letter == "F") row[1] -= step
		else row[0] += step
	}

	for (let i = 0; i < cols.length; i++) {
		const step = 8 / Math.pow(2, i + 1),
			letter = cols[i]
		if (letter == "L") col[1] -= step
		else col[0] += step
	}

	return row[0] * 8 + col[0]
}
