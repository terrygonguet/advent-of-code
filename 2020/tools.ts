// Utilities to make TS shut up about reducing and mapping

export function toInt(n: string) {
	return parseInt(n)
}

export function min(a: number, b: number) {
	return Math.min(a, b)
}

export function max(a: number, b: number) {
	return Math.max(a, b)
}

export function wait(ms: number) {
	return new Promise(resolve => setTimeout(resolve, ms))
}

export function last<T>(arr: T[]) {
	return arr[arr.length - 1]
}

export function sum(arr: number[]) {
	return arr.reduce((acc, cur) => acc + cur, 0)
}
