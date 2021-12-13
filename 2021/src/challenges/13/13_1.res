module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = ((a0, a1), (b0, b1)) =>
    switch Pervasives.compare(a0, b0) {
    | 0 => Pervasives.compare(a1, b1)
    | c => c
    }
})

type dot = (int, int)
type dots = Belt.Set.t<dot, PairComparator.identity>
type fold = Up(int) | Left(int)

let parseDot: string => option<dot> = str =>
  switch str->Js.String2.split(",") {
  | [x, y] =>
    switch Belt.Int.fromString(x) {
    | Some(x) =>
      switch Belt.Int.fromString(y) {
      | Some(y) => Some((x, y))
      | None => None
      }
    | None => None
    }
  | _ => None
  }

let parseFold: string => option<fold> = str =>
  switch str->Js.String2.split("=") {
  | [prefix, n] if prefix->Js.String2.startsWith("fold along") =>
    switch Belt.Int.fromString(n) {
    | Some(n) =>
      switch prefix->Js.String2.split(" ") {
      | [_, _, axis] if axis == "x" => Some(Left(n))
      | [_, _, axis] if axis == "y" => Some(Up(n))
      | _ => None
      }
    | None => None
    }
  | _ => None
  }

let applyFold = (dots: dots, fold: fold) =>
  switch fold {
  | Up(n) =>
    dots
    ->Belt.Set.toArray
    ->Js.Array2.map(((x, y)) => y > n ? (x, n - (y - n)) : (x, y))
    ->Js.Array2.filter(((_, y)) => y < n)
    ->Belt.Set.fromArray(~id=module(PairComparator))
  | Left(n) =>
    dots
    ->Belt.Set.toArray
    ->Js.Array2.map(((x, y)) => x > n ? (n - (x - n), y) : (x, y))
    ->Js.Array2.filter(((x, _)) => x < n)
    ->Belt.Set.fromArray(~id=module(PairComparator))
  }

let stringify = (dots: dots) => {
  let (maxx, maxy) =
    dots->Belt.Set.reduce((0, 0), ((maxx, maxy), (x, y)) => (max(maxx, x), max(maxy, y)))
  let grid = Belt.Array.makeBy(maxy + 1, _ => Belt.Array.make(maxx + 1, "  "))
  dots->Belt.Set.forEach(((x, y)) => grid->Grid.unsafe_set(x, y, `██`))
  grid->Js.Array2.map(line => line->Js.Array2.joinWith(""))->Js.Array2.joinWith("\n")
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let blocks = inpt->String2.split("\n\n")
  let dots =
    blocks
    ->Array2.unsafe_get(0)
    ->String2.split("\n")
    ->Array2.map(parseDot)
    ->Utils.keepSomeAndGet
    ->Set.fromArray(~id=module(PairComparator))
  let folds =
    blocks->Array2.unsafe_get(1)->String2.split("\n")->Array2.map(parseFold)->Utils.keepSomeAndGet

  folds->Array2.reduce((dots, fold) => dots->applyFold(fold), dots)->stringify
}
