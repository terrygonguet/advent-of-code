type position = (int, int, int)
type cuboid = {
  x: (int, int),
  y: (int, int),
  z: (int, int),
  val: bool,
}

module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int, int)
  let cmp = ((a0, a1, a2), (b0, b1, b2)) =>
    switch a0 - b0 {
    | 0 =>
      switch a1 - b1 {
      | 0 => a2 - b2
      | c => c
      }
    | c => c
    }
})

let parseInterval: string => option<(int, int)> = str => {
  let re = %re(`/^[xyz]=(-?\d+)\.\.(-?\d+)$/`)
  let captures = switch re->Js.Re.exec_(str) {
  | Some(result) => result->Js.Re.captures->Utils.unwrapNullableArray
  | None => []
  }
  switch captures {
  | [_, a, b] =>
    switch (Belt.Int.fromString(a), Belt.Int.fromString(b)) {
    | (Some(a), Some(b)) => Some((min(a, b), max(a, b)))
    | _ => None
    }
  | _ => None
  }
}

let parseCuboid: string => option<cuboid> = str =>
  switch str->Js.String2.split(" ") {
  | [val, coords] =>
    switch coords->Js.String2.split(",") {
    | [x, y, z] =>
      switch [x, y, z]->Js.Array2.map(parseInterval) {
      | [Some(x), Some(y), Some(z)] => Some({x: x, y: y, z: z, val: val == "on"})
      | _ => None
      }
    | _ => None
    }
  | _ => None
  }

let default = (inpt: string) => {
  open Js
  open! Belt

  let cuboids = inpt->String2.split("\n")->Array2.map(parseCuboid)->Utils.unwrapOptionArray
  let grid = MutableMap.make(~id=module(PairComparator))

  cuboids->Array2.forEach(({x: (x1, x2), y: (y1, y2), z: (z1, z2), val}) => {
    for x in max(x1, -50) to min(x2, 50) {
      for y in max(y1, -50) to min(y2, 50) {
        for z in max(z1, -50) to min(z2, 50) {
          grid->MutableMap.set((x, y, z), val)
        }
      }
    }
  })

  grid->MutableMap.reduce(0, (acc, _, v) => acc + (v ? 1 : 0))
}
