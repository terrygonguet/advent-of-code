type cuboid = {
  x: (int, int),
  y: (int, int),
  z: (int, int),
  val: bool,
}

type rec node = {
  cuboid: cuboid,
  children: array<node>,
}

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

let doesCuboidsIntersect = (a: cuboid, b: cuboid) => {
  false
}

let addCuboid = (node: node, cuboid: cuboid) => {
  let {cuboid: cur, children} = node
  children->Js.Array2.forEach(node => node->addCuboid(cuboid))
  if cuboid.val != cur.val && cur->doesCuboidsIntersect(cuboid) {
    children->Js.Array2.push({cuboid: cuboid, children: []})
  }
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let cuboids = inpt->String2.split("\n")->Array2.map(parseCuboid)->Utils.unwrapOptionArray
}
