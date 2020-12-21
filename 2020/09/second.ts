import { min, max } from "../tools.ts"

export default function (input: string) {
	const nums = input.split("\n").map(n => parseInt(n)),
		winSize = 25

	for (let i = winSize; i < nums.length; i++) {
		if (!isValid(nums[i], nums.slice(i - winSize, i))) {
			const invalid = nums[i]
			for (let start = 0; start < nums.length; start++) {
				let suite = [nums[start]]
				for (let end = start + 1; end < nums.length - 1; end++) {
					suite.push(nums[end])
					const sum = suite.reduce((acc, cur) => acc + cur, 0)
					if (sum == invalid) {
						const _min = suite.reduce(min),
							_max = suite.reduce(max)
						return _min + _max
					} else if (sum > invalid) break
				}
			}
		}
	}
	throw new Error("Shouldn't happen")
}

function isValid(n: number, previous: number[]) {
	for (let a = 0; a < previous.length; a++) {
		for (let b = 0; b < previous.length; b++) {
			const A = previous[a],
				B = previous[b]
			if (A + B == n && A != B) return true
		}
	}
	return false
}
