type Passport = {
	byr: number
	iyr: number
	eyr: number
	hgt: number
	hcl: string
	ecl: string
	pid: string
}

export default function (input: string) {
	const passports = input.split("\n\n")
	let nbValids = 0

	for (const passport of passports) {
		const fields = passport.trim().replace(/\s/g, " ").split(" ")
		const obj = Object.fromEntries(fields.map(f => f.split(":")))
		if (isValidPassport(obj)) nbValids++
	}

	return nbValids
}

function isValidPassport(obj: { [key: string]: string }) {
	if (!obj.byr || obj.byr.length != 4) return false
	if (!obj.iyr || obj.iyr.length != 4) return false
	if (!obj.eyr || obj.eyr.length != 4) return false
	if (!obj.hgt || !(obj.hgt.endsWith("in") || obj.hgt.endsWith("cm"))) return false
	if (!obj.hcl || !/^#[0-9a-f]{6}$/.test(obj.hcl)) return false
	if (!obj.ecl || !eyeColors.includes(obj.ecl)) return false
	if (!obj.pid || !/^\d{9}$/.test(obj.pid)) return false

	const passport: Passport = {
		byr: parseInt(obj.byr),
		iyr: parseInt(obj.iyr),
		eyr: parseInt(obj.eyr),
		hgt: parseInt(obj.hgt),
		hcl: obj.hcl,
		ecl: obj.ecl,
		pid: obj.pid,
	}
	if (isNaN(passport.byr) || passport.byr > 2002 || passport.byr < 1920) return false
	if (isNaN(passport.iyr) || passport.iyr > 2020 || passport.iyr < 2010) return false
	if (isNaN(passport.eyr) || passport.eyr > 2030 || passport.eyr < 2020) return false
	if (isNaN(passport.hgt)) return false
	if (obj.hgt.endsWith("in") && (passport.hgt < 59 || passport.hgt > 76)) return false
	if (obj.hgt.endsWith("cm") && (passport.hgt < 150 || passport.hgt > 193)) return false

	return true
}

const eyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
