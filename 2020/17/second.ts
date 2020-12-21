import { sum } from "../tools.ts"

type Point = [number, number, number, number]

export default function (input: string) {
	let space = new Map<Point, boolean>()
	const lines = input.split("\n")

	for (let y = 0; y < lines.length; y++) {
		for (let x = 0; x < lines[0].length; x++) {
			set(space, pt(x, y), lines[y][x] == "#")
		}
	}

	for (let i = 0; i < 6; i++) {
		const next = new Map<Point, boolean>(),
			{ minx, miny, minz, minw, maxx, maxy, maxz, maxw } = set
		for (let x = minx - 1; x <= maxx + 1; x++) {
			for (let y = miny - 1; y <= maxy + 1; y++) {
				for (let z = minz - 1; z <= maxz + 1; z++) {
					for (let w = minw - 1; w <= maxw + 1; w++) {
						const p = pt(x, y, z, w),
							n = nbNeighbours(space, p)
						if (n == 3) set(next, p, true)
						else if (n == 2) set(next, p, !!space.get(p))
						else set(next, p, false)
					}
				}
			}
		}
		console.log(`Step ${i + 1} done`)
		space = next
	}

	return sum(Array.from(space.values()) as any[])
}

const cache = new Map<string, Point>()
function pt(x = 0, y = 0, z = 0, w = 0) {
	const key = `${x} ${y} ${z} ${w}`
	if (cache.has(key)) return cache.get(key) as Point
	else {
		const p = [x, y, z, w] as Point
		cache.set(key, p)
		return p
	}
}

function set(space: Map<Point, boolean>, p: Point, value = true) {
	set.minx = Math.min(set.minx, p[0])
	set.maxx = Math.max(set.maxx, p[0])
	set.miny = Math.min(set.miny, p[1])
	set.maxy = Math.max(set.maxy, p[1])
	set.minz = Math.min(set.minz, p[2])
	set.maxz = Math.max(set.maxz, p[2])
	set.minw = Math.min(set.minw, p[3])
	set.maxw = Math.max(set.maxw, p[3])
	return space.set(p, value)
}
set.minx = 0
set.maxx = 0
set.miny = 0
set.maxy = 0
set.minz = 0
set.maxz = 0
set.minw = 0
set.maxw = 0

function nbNeighbours(space: Map<Point, boolean>, p: Point) {
	const [x, y, z, w] = p
	let total = 0
	for (let dx = -1; dx <= 1; dx++) {
		for (let dy = -1; dy <= 1; dy++) {
			for (let dz = -1; dz <= 1; dz++) {
				for (let dw = -1; dw <= 1; dw++) {
					if (!dx && !dy && !dz && !dw) continue
					total += space.get(pt(dx + x, dy + y, dz + z, dw + w)) ? 1 : 0
				}
			}
		}
	}
	return total
}
