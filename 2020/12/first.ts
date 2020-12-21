type Instruction = [string, number]
type Position = [number, number]
enum Direction {
	North = 0,
	East = 1,
	South = 2,
	West = 3,
}

export default function (input: string) {
	const instructions = input.split("\n").map(parse)
	let pos: Position = [0, 0],
		wp: Position = [10, -1]

	console.log(pos, wp)
	for (const instruction of instructions) {
		const [a, b] = instruction
		switch (a) {
			case "N":
				wp[1] -= b
				break
			case "S":
				wp[1] += b
				break
			case "E":
				wp[0] += b
				break
			case "W":
				wp[0] -= b
				break
			case "R":
				for (let i = 0; i < b / 90; i++) {
					wp = [-wp[1], wp[0]]
				}
				break
			case "L":
				for (let i = 0; i < b / 90; i++) {
					wp = [wp[1], -wp[0]]
				}
				break
			case "F":
				pos[0] += wp[0] * b
				pos[1] += wp[1] * b
				break
		}
		console.log(instruction, pos, wp)
	}

	return Math.abs(pos[0]) + Math.abs(pos[1])
}

function parse(str: string): Instruction {
	return [str[0], parseInt(str.slice(1))]
}

function mod(a: number, b: number) {
	if (a >= 0) return a % b
	else return (a + Math.ceil(a / -b) * b) % b
}
