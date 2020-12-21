export default function (input: string) {
	const adapters = input
		.split("\n")
		.map(x => parseInt(x))
		.sort((a, b) => a - b)

	const diffs = adapters.map((a, i, arr) => (i == 0 ? a : a - arr[i - 1]))
	diffs.push(3)

	let oneCounts = [0]
	for (const diff of diffs) {
		if (diff === 3) {
			oneCounts.push(0)
		} else {
			oneCounts[oneCounts.length - 1] += 1
		}
	}
	oneCounts = oneCounts.filter(Boolean)
	return oneCounts.reduce((product, oneCount) => product * combCount(oneCount), 1)
}

function combCount(n: number): number {
	if (n === 1) return 1
	if (n === 2) return 2
	if (n === 3) return 4
	return combCount(n - 1) + combCount(n - 2) + combCount(n - 3)
}

/**
 * One count method
 *
 * Observe that the diff is either 1 or 3. There is only one way to go between adapters with diff 3
 * from one another. However, when there is a contiguous group of adapters whose diffs are all 1 from
 * the preview to next, then there will be more than one way to go from the first and last adapters
 * within this group.
 *
 * For instance, there are 2 ways if the diff group is: [1, 1]; 4 ways if [1, 1, 1], and so on. The number
 * of ways can be computed recursively.
 */
