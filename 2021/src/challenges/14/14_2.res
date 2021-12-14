type rule = (string, string, string)
type transformMap = Belt.Map.String.t<(string, string)>
type pairs = Belt.Map.String.t<BigInt.t>

let parseRule: string => option<rule> = str =>
  switch str->Js.String2.split(" -> ") {
  | [a, b] if b->Js.String2.length == 1 =>
    switch a->Js.String2.split("") {
    | [a1, a2] => Some((a, a1 ++ b, b ++ a2))
    | _ => None
    }
  | _ => None
  }

let makeTransformMap: array<rule> => transformMap = rules =>
  rules->Js.Array2.reduce(
    (map, (a, b, c)) => map->Belt.Map.String.set(a, (b, c)),
    Belt.Map.String.empty,
  )

let biginc = (n: BigInt.t, m: option<BigInt.t>) =>
  switch m {
  | Some(m) => Some(BigInt.add(m, n))
  | None => Some(n)
  }

let toPairs: string => pairs = polymer => {
  let chars = Js.Array2.from(Js.String2.castToArrayLike(polymer))
  let pairs = Belt.Array.zipBy(chars, chars->Belt.Array.sliceToEnd(1), (a, b) => a ++ b)

  pairs->Js.Array2.reduce(
    (map, pair) => map->Belt.Map.String.update(pair, biginc(BigInt.fromInt(1))),
    Belt.Map.String.empty,
  )
}

let step = (polymer: pairs, transformMap: transformMap) =>
  polymer->Belt.Map.String.reduce(Belt.Map.String.empty, (next, pair, n) => {
    let (a, b) = transformMap->Belt.Map.String.getExn(pair)
    let next = next->Belt.Map.String.update(a, biginc(n))
    let next = next->Belt.Map.String.update(b, biginc(n))
    next
  })

let score = (polymer: pairs, firstLetter: string) => {
  let map =
    polymer->Belt.Map.String.reduce(Belt.Map.String.empty, (map, pair, n) =>
      map->Belt.Map.String.update(
        Js.String2.split(pair, "")->Utils.last->Js.Option.getExn,
        biginc(n),
      )
    )
  let map = map->Belt.Map.String.update(firstLetter, biginc(BigInt.fromInt(0)))

  let (max, min) =
    map
    ->Belt.Map.String.toArray
    ->Js.Array2.reduce(
      ((maxval, minval), (_, val)) => (BigInt.max(val, maxval), BigInt.min(val, minval)),
      (BigInt.zero, BigInt.fromString("9999999999999999999999")),
    )

  max->BigInt.sub(min)
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

  let polymer = ref(template->toPairs)
  for _ in 1 to 40 {
    polymer := step(polymer.contents, transformMap)
  }

  score(polymer.contents, template->String2.split("")->Array2.unsafe_get(0))
}
