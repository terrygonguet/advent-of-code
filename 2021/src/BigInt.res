type t

@val external fromInt: int => t = "BigInt"
@val external fromString: string => t = "BigInt"

let add: (t, t) => t = %raw("(a, b) => a + b")
let sub: (t, t) => t = %raw("(a, b) => a - b")
let mult: (t, t) => t = %raw("(a, b) => a * b")
let eq: (t, t) => bool = %raw("(a, b) => a == b")
let cmp: (t, t) => int = %raw("(a, b) => a == b ? 0 : (a < b ? -1 : 1)")
let max: (t, t) => t = %raw("(a, b) => a - b > 0n ? a : b")
let min: (t, t) => t = %raw("(a, b) => a - b < 0n ? a : b")

let zero: t = %raw("0n")
