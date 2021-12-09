let default = (inpt: string) => {
  open Js
  open! Belt

  let lines =
    inpt
    ->String2.split("\n")
    ->Array2.map(line => Array2.fromMap(String2.castToArrayLike(line), int_of_string))

  let lows = lines->Array2.mapi((line, y) =>
    line->Array2.mapi((n, x) => {
      let up = lines->Utils.getOrDefault(y - 1, [])
      let down = lines->Utils.getOrDefault(y + 1, [])
      n < line->Utils.getOrDefault(x - 1, 9) &&
      n < line->Utils.getOrDefault(x + 1, 9) &&
      n < up->Utils.getOrDefault(x, 9) &&
      n < down->Utils.getOrDefault(x, 9)
        ? n + 1
        : 0
    })
  )

  lows->Array2.reduce((acc, cur) => acc + cur->Array2.reduce((acc, cur) => acc + cur, 0), 0)
}
