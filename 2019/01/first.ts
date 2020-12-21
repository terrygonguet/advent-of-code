export default function (input: string) {
	const masses = input.split("\n").map(n => parseInt(n))
	const fuel = masses.map(m => Math.floor(m / 3) - 2)
	return fuel.reduce((acc, cur) => acc + cur, 0)
}
