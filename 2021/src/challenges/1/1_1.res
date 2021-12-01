let default = (input: string) => {
  open Js.Array2

  let depths =
    input
    ->Js.String2.split("\n")
    ->map(Belt.Int.fromString)
    ->filter(Belt.Option.isSome)
    ->map(Belt.Option.getUnsafe)
  let depthsOffset = Belt.Array.copy(depths)
  depthsOffset->unshift(Js.Int.max)->ignore
  let deltas = Belt.Array.zipByU(depths, depthsOffset, (. a, b) => a > b ? 1 : 0)
  deltas->reduce((a, b) => a + b, 0)
}
