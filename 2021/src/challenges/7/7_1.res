let default = (inpt: string) => {
  open Js
  open! Belt

  let positions = inpt->String2.split(",")->Array2.map(int_of_string)
  let maxx = positions->Array2.reduce(max, 0)
  let deltas = Array.make(maxx, 0)
  let costs =
    deltas->Array2.mapi((_, i) => positions->Array2.reduce((acc, cur) => acc + abs(cur - i), 0))

  costs->Array2.reducei((acc, cur, i) => {
    let (_, maxCost) = acc
    cur < maxCost ? (i, cur) : acc
  }, (0, max_int))
}
