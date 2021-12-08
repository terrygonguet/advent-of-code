let sort = (str: string) => str->Js.String2.split("")->Js.Array2.sortInPlace->Js.Array2.joinWith("")

let intersect = (a: string, b: string) =>
  Js.Array2.from(a->Js.String2.castToArrayLike)
  ->Js.Array2.filter(char => b->Js.String2.includes(char))
  ->Js.Array2.joinWith("")

let exclude = (a: string, b: string) =>
  Js.Array2.from(a->Js.String2.castToArrayLike)
  ->Js.Array2.filter(char => b->Js.String2.includes(char)->not)
  ->Js.Array2.joinWith("")

let deduceMapping = (~one: string, ~seven: string, ~four: string, ~commonTo069: string) => {
  open! Belt

  let all = "abcdefg"
  let a = commonTo069->intersect(seven)->exclude(one ++ four)
  let b = commonTo069->intersect(four)->exclude(one ++ seven)
  let c = one->exclude(commonTo069)
  let d = four->exclude(one ++ seven ++ commonTo069)
  let e = all->exclude(four ++ commonTo069)
  let f = commonTo069->intersect(one)
  let g = commonTo069->exclude(one ++ four ++ seven)

  Map.String.empty
  ->Map.String.set(sort(a ++ b ++ c ++ e ++ f ++ g), 0)
  ->Map.String.set(one, 1)
  ->Map.String.set(sort(a ++ c ++ d ++ e ++ g), 2)
  ->Map.String.set(sort(a ++ c ++ d ++ f ++ g), 3)
  ->Map.String.set(four, 4)
  ->Map.String.set(sort(a ++ b ++ d ++ f ++ g), 5)
  ->Map.String.set(sort(a ++ b ++ d ++ e ++ f ++ g), 6)
  ->Map.String.set(seven, 7)
  ->Map.String.set(sort(a ++ b ++ c ++ d ++ e ++ f ++ g), 8)
  ->Map.String.set(sort(a ++ b ++ c ++ d ++ f ++ g), 9)
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let displays =
    inpt
    ->String2.split("\n")
    ->Array2.map(line => line->String2.split(" | "))
    ->Array2.map(line =>
      switch line {
      | [a, b] => (a->String2.split(" ")->Array2.map(sort), b->String2.split(" ")->Array2.map(sort))
      | _ => Exn.raiseError("Got invalid line: " ++ line->Array2.joinWith(", "))
      }
    )

  let codes = displays->Array2.map(((segments, codes)) => {
    let one = segments->Array2.find(s => s->String2.length == 2)->Option.getUnsafe
    let four = segments->Array2.find(s => s->String2.length == 4)->Option.getUnsafe
    let seven = segments->Array2.find(s => s->String2.length == 3)->Option.getUnsafe
    let commonTo069 =
      segments
      ->Array2.filter(s => s->String2.length == 6)
      ->Array2.reduce((acc, cur) => acc->intersect(cur), "abcdefg")

    let mapping = deduceMapping(~one, ~four, ~seven, ~commonTo069)

    codes
    ->Array2.map(code => mapping->Map.String.getExn(code))
    ->Array2.map(string_of_int)
    ->Array2.joinWith("")
    ->int_of_string
  })

  codes->Array2.reduce((a, b) => a + b, 0)
}
