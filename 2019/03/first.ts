import { min, toInt } from "../tools.ts"

type Position = [number, number]

export default function (input: string) {
	const wires = input.split("\n"),
		[coords1, coords2] = wires.map(wire2coords),
		intersections = new Set<string>()

	coords1.forEach(c => {
		if (coords2.has(c)) intersections.add(c)
	})

	return Array.from(intersections)
		.map(c => c.split(" ").map(toInt) as Position)
		.map(manhattan)
		.reduce(min, Infinity)
}

function manhattan([x, y]: Position) {
	return Math.abs(x) + Math.abs(y)
}

function wire2coords(wire: string) {
	const moves = wire.split(","),
		coords = new Set<string>()
	let curPos: Position = [0, 0]

	for (const move of moves) {
		const direction = move[0],
			distance = parseInt(move.slice(1)),
			toAdd: Position[] = []
		switch (direction) {
			case "U":
				toAdd.push(
					...Array(distance)
						.fill(0)
						.map((_, i) => [curPos[0], curPos[1] - (i + 1)] as Position),
				)
				curPos[1] -= distance
				break
			case "D":
				toAdd.push(
					...Array(distance)
						.fill(0)
						.map((_, i) => [curPos[0], curPos[1] + (i + 1)] as Position),
				)
				curPos[1] += distance
				break
			case "L":
				toAdd.push(
					...Array(distance)
						.fill(0)
						.map((_, i) => [curPos[0] - (i + 1), curPos[1]] as Position),
				)
				curPos[0] -= distance
				break
			case "R":
				toAdd.push(
					...Array(distance)
						.fill(0)
						.map((_, i) => [curPos[0] + (i + 1), curPos[1]] as Position),
				)
				curPos[0] += distance
				break
		}
		toAdd.forEach(([x, y]) => coords.add(`${x} ${y}`))
	}

	return coords
}
