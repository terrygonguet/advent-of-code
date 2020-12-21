export default function (input: string) {
	const numbers = input.split("\n").map(n => parseInt(n))

	for (let i = 0; i < numbers.length; i++) {
		for (let j = 0; j < numbers.length; j++) {
			if (numbers[i] + numbers[j] == 2020) return numbers[i] * numbers[j]
		}
	}

	throw new Error("This should not happen")
}
