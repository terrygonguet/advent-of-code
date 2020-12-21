import { toInt } from "../tools.ts"

export default function (input: string) {
	const [min, max] = input.split("-").map(toInt)
	let nbValid = 0

	for (let i = min; i <= max; i++) {
		if (isValidPassword(i)) nbValid++
	}

	return nbValid
}

function isValidPassword(candidate: number) {
	const str = candidate.toString()
	let hasDouble = false

	for (let i = 0; i < 5; i++) {
		if (str[i + 1] < str[i]) return false
		if (str[i] == str[i + 1] && str[i] != str[i + 2] && str[i] != str[i - 1]) hasDouble = true
	}

	return hasDouble
}
