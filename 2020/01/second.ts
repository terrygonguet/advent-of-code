export default function (input: string) {
	const numbers = input.split("\n").map(n => parseInt(n))

	for (let i = 0; i < numbers.length; i++) {
		for (let j = 0; j < numbers.length; j++) {
			for (let k = 0; k < numbers.length; k++) {
				if (numbers[i] + numbers[j] + numbers[k] == 2020) return numbers[i] * numbers[j] * numbers[k]
			}
		}
	}

	throw new Error("This should not happen")
}
