export default function (input: string) {
	const masses = input.split("\n").map(n => parseInt(n))
	const fuel = masses.map(fuelFor).reduce((acc, cur) => acc + cur, 0)
	return fuel
}

function fuelFor(mass: number): number {
	let fuel = Math.floor(mass / 3) - 2
	if (fuel > 0) return fuel + fuelFor(fuel)
	else return 0
}
