export default function (input: string) {
	const [line1, line2] = input.split("\n"),
		time = parseInt(line1),
		schedule = line2
			.split(",")
			.filter(n => n != "x")
			.map(n => parseInt(n))
	let id = 0,
		minWait = Infinity
	for (let i = 0; i < schedule.length; i++) {
		let wait = schedule[i] - (time % schedule[i])
		if (wait < minWait) {
			minWait = wait
			id = schedule[i]
		}
	}

	return id * minWait
}
