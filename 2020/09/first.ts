export default function (input: string) {
	const nums = input.split("\n").map(n => parseInt(n)),
		winSize = 25

	for (let i = winSize; i < nums.length; i++) {
		if (!isValid(nums[i], nums.slice(i - winSize, i))) return nums[i]
	}
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
