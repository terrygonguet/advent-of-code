import { min } from "../tools.ts"

type Position = [number, number]

export default function (input: string) {
	const wires = input.split("\n"),
		[coords1, coords2] = wires.map(wire2coords),
		intersections = new Map<string, number>()

	coords1.forEach((v, k) => {
		const other = coords2.get(k)
		if (other) intersections.set(k, Math.min(intersections.get(k) || Infinity, v + other))
	})
	console.log(intersections)

	return Array.from(intersections.values()).reduce(min, Infinity)
}

function wire2coords(wire: string) {
	const moves = wire.split(","),
		coords = new Map<string, number>()
	let curPos: Position = [0, 0],
		step = 0

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
		toAdd.forEach(([x, y]) => {
			const key = `${x} ${y}`,
				next = ++step
			if (!coords.has(key)) coords.set(key, next)
		})
	}

	return coords
}
