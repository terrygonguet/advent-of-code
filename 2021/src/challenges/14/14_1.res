type rule = (string, string)
type transformMap = Belt.Map.String.t<string>

let parseRule: string => option<rule> = str =>
  switch str->Js.String2.split(" -> ") {
  | [a, b] if b->Js.String2.length == 1 =>
    switch a->Js.String2.split("") {
    | [a1, _] => Some((a, a1 ++ b))
    | _ => None
    }
  | _ => None
  }

let makeTransformMap: array<rule> => transformMap = rules =>
  rules->Js.Array2.reduce((map, (a, b)) => map->Belt.Map.String.set(a, b), Belt.Map.String.empty)

let toPairs = (polymer: string) => {
  let chars = Js.Array2.from(Js.String2.castToArrayLike(polymer))
  Belt.Array.zipBy(chars, chars->Belt.Array.sliceToEnd(1), (a, b) => a ++ b)->Js.Array2.concat(
    [Utils.last(chars)]->Utils.unwrapOptionArray,
  )
}

let step = (polymer: string, transformMap: transformMap) =>
  polymer
  ->toPairs
  ->Js.Array2.map(pair => transformMap->Belt.Map.String.get(pair) |> Js.Option.getWithDefault(pair))
  ->Js.Array2.joinWith("")

let score = (polymer: string) => {
  let chars = Js.Array2.from(Js.String2.castToArrayLike(polymer))
  let map = chars->Js.Array2.reduce((map, char) =>
    map->Belt.Map.String.update(char, n =>
      switch n {
      | Some(n) => Some(n + 1)
      | None => Some(1)
      }
    )
  , Belt.Map.String.empty)

  let (max, min) =
    map
    ->Belt.Map.String.toArray
    ->Js.Array2.reduce(
      ((maxval, minval), (_, val)) => (max(val, maxval), min(val, minval)),
      (0, Js.Int.max),
    )

  max - min
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let parts = inpt->String2.split("\n\n")
  let template = parts->Array2.unsafe_get(0)
  let transformMap =
    parts
    ->Array2.unsafe_get(1)
    ->String2.split("\n")
    ->Array2.map(parseRule)
    ->Utils.unwrapOptionArray
    ->makeTransformMap

  let polymer = ref(template)
  for _ in 1 to 10 {
    polymer := step(polymer.contents, transformMap)
  }

  polymer.contents->score
}
