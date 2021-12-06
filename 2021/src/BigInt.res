type t

@val external fromInt: int => t = "BigInt"

let add: (t, t) => t = %raw("(a, b) => a + b")

let zero: t = %raw("0n")
