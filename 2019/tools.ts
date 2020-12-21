// Utilities to make TS shut up about reducing and mapping

export function toInt(n: string) {
	return parseInt(n)
}

export function min(a: number, b: number) {
	return Math.min(a, b)
}

export function wait(ms: number) {
	return new Promise(resolve => setTimeout(resolve, ms))
}

export function randomItem<T>(arr: T[]) {
	return arr[Math.floor(Math.random() * arr.length)]
}
