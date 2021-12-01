let getWithDefault = (arr: array<'a>, i: int, default: 'a) =>
  arr->Belt.Array.get(i)->Belt.Option.getWithDefault(default)

let default = (input: string) => {
  open Js.Array2

  let depths =
    input
    ->Js.String2.split("\n")
    ->map(Belt.Int.fromString)
    ->filter(Belt.Option.isSome)
    ->map(Belt.Option.getUnsafe)
  let windowedDepths =
    depths->mapi((depth, i) =>
      depth + depths->getWithDefault(i + 1, 0) + depths->getWithDefault(i + 2, 0)
    )
  let depthsOffset = Belt.Array.copy(windowedDepths)
  depthsOffset->unshift(Js.Int.max)->ignore
  let deltas = Belt.Array.zipByU(windowedDepths, depthsOffset, (. a, b) => a > b ? 1 : 0)
  deltas->reduce((a, b) => a + b, 0)
}
