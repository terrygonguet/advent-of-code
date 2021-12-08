let default = (inpt: string) => {
  open Js
  open! Belt

  let displays =
    inpt
    ->String2.split("\n")
    ->Array2.map(line => line->String2.split(" | "))
    ->Array2.map(line =>
      switch line {
      | [a, b] => (a->String2.split(" "), b->String2.split(" "))
      | _ => Exn.raiseError("Got invalid line: " ++ line->Array2.joinWith(", "))
      }
    )
  let easyNumbers = [2, 3, 4, 7]
  displays->Array2.reduce(
    (acc, (_, numbers)) =>
      acc +
      numbers->Array2.reduce(
        (acc, cur) => acc + (easyNumbers->Array2.includes(cur->String2.length) ? 1 : 0),
        0,
      ),
    0,
  )
}
