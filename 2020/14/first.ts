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
	const instructions = input.split("\n").map(parse),
		mem: number[] = []
	let mask = "X".repeat(36)

	for (const instruction of instructions) {
		switch (instruction.op) {
			case "mask":
				mask = instruction.mask
				break
			case "mem":
				const bin = instruction.val.toString(2).padStart(36, "0")
				let maskedVal = 0
				for (let i = 0; i < mask.length; i++) {
					if (mask[i] == "X") maskedVal += bin[i] == "1" ? 2 ** (35 - i) : 0
					else maskedVal += mask[i] == "1" ? 2 ** (35 - i) : 0
				}
				mem[instruction.addr] = maskedVal
				break
		}
	}

	return mem.reduce((acc, cur) => acc + cur, 0)
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
