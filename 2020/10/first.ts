export default function (input: string) {
	const adapters = input
			.split("\n")
			.map(x => parseInt(x))
			.sort((a, b) => a - b),
		jumps = [0, 0, 0, 0]
	let prev = 0
	for (const adapter of adapters) {
		jumps[adapter - prev]++
		prev = adapter
	}
	jumps[3]++ // last phone adapter
	return jumps[1] * jumps[3]
}
