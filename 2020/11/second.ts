export default function (input: string) {
	let lines = input.split("\n").map(l => l.split("")),
		n = 0
	for (const step of run(lines)) {
		lines = step
	}

	const d = display(lines)
	console.log(d)

	return d.split("").filter(c => c == "#").length
}

function* run(grid: string[][]) {
	let next = [],
		changed = false
	do {
		next = []
		changed = false
		for (let y = 0; y < grid.length; y++) {
			next.push(Array(grid[y].length).fill("."))
			for (let x = 0; x < grid[y].length; x++) {
				if (grid[y][x] == ".") continue
				const taken = [
					los(grid, [x, y], [-1, -1]),
					los(grid, [x, y], [-1, 0]),
					los(grid, [x, y], [-1, 1]),
					los(grid, [x, y], [0, -1]),
					los(grid, [x, y], [0, 1]),
					los(grid, [x, y], [1, -1]),
					los(grid, [x, y], [1, 0]),
					los(grid, [x, y], [1, 1]),
				].filter(n => n == "#").length

				if (taken >= 5) next[y][x] = "L"
				else if (taken == 0) next[y][x] = "#"
				else next[y][x] = grid[y][x]
			}
		}
		changed = display(grid) != display(next)
		grid = next
		yield grid
	} while (changed)
	return next
}

function los(grid: string[][], [x, y]: [number, number], [deltaX, deltaY]: [number, number]) {
	let char
	do {
		x += deltaX
		y += deltaY
		char = grid[y]?.[x]
	} while (char == ".")
	return char
}

function display(grid: string[][]) {
	return grid.map(r => r.join("")).join("\n")
}
