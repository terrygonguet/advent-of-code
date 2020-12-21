type Instruction = MaskInstruction | MemInstruction
type MaskInstruction = {
	op: "mask"
	mask: string
}
type MemInstruction = {
	op: "mem"
	addr: number
	val: number
}

export default function (input: string) {
	const instructions = input.split("\n").map(parse)
	let mask = "X".repeat(36),
		i = 0,
		mem: { [index: string]: number } = {}

	console.log("Computing...")
	for (const instruction of instructions) {
		switch (instruction.op) {
			case "mask":
				mask = instruction.mask
				break
			case "mem":
				const bin = instruction.addr.toString(2).padStart(36, "0")
				let maskedAddr = ""
				for (let i = 0; i < mask.length; i++) {
					if (mask[i] == "X") maskedAddr += "X"
					else maskedAddr += mask[i] == "1" ? "1" : bin[i]
				}
				setmem(mem, maskedAddr, instruction.val)
				break
		}
	}

	console.log("Summing...")
	return Object.values(mem).reduce((acc, cur) => acc + (cur ?? 0), 0)
}

function setmem(mem: { [index: string]: number }, addr: string, val: number) {
	const i = addr.indexOf("X")
	if (i == -1) {
		// console.log(`Set addr ${addr} (${parseInt(addr, 2)}) to ${val} - final`)
		mem[parseInt(addr, 2)] = val
	} else {
		// console.log(`Set addr ${addr} to ${val}`)
		setmem(mem, addr.slice(0, i) + "0" + addr.slice(i + 1), val)
		setmem(mem, addr.slice(0, i) + "1" + addr.slice(i + 1), val)
	}
}

function parse(str: string): Instruction {
	if (str.startsWith("mask")) {
		return {
			op: "mask",
			mask: str.slice(7),
		}
	} else {
		const [_, addr, val] = /^mem\[(\d*)\]\s=\s(\d*)$/.exec(str) ?? []
		if (!_) throw new Error(`wat ${str} ${addr} ${val}`)
		return {
			op: "mem",
			addr: parseInt(addr),
			val: parseInt(val),
		}
	}
}
