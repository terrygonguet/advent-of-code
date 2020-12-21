export default function (input: string) {
	const passports = input.split("\n\n")
	let nbValids = 0

	for (const passport of passports) {
		const fields = passport.replace(/\s/g, " ").split(" ")
		const keys = fields.map(f => f.split(":")[0].toLocaleLowerCase())
		if (keys.length == 8 || hasAllFieldsButCID(keys)) nbValids++
	}

	return nbValids
}

function hasAllFieldsButCID(keys: string[]) {
	if (keys.length != 7) return false
	else return keys.reduce((acc, cur) => acc && cur != "cid", true)
}
