type position = (int, int, int)
type beacons = array<position>
type scanner = {id: int, beacons: beacons}

let cmpPos: (position, position) => int = ((x1, y1, z1), (x2, y2, z2)) =>
  switch Pervasives.compare(x1, x2) {
  | 0 =>
    switch Pervasives.compare(y1, y2) {
    | 0 => Pervasives.compare(z1, z2)
    | c => c
    }
  | c => c
  }

module PositionComparator = Belt.Id.MakeComparable({
  type t = position
  let cmp = cmpPos
})

let parsePosition: string => option<position> = str => {
  let parts =
    str->Js.String2.split(",")->Js.Array2.map(Belt.Int.fromString)->Utils.unwrapOptionArray
  switch parts {
  | [x, y, z] => Some((x, y, z))
  | _ => None
  }
}

let parseScanner: string => option<scanner> = str => {
  open Js
  open! Belt

  let lines = str->String2.split("\n")
  let first = lines->Array2.shift

  switch first {
  | None => None
  | Some(first) => {
      let re = %re(`/--- scanner (\d+) ---/`)
      let result =
        re
        ->Re.exec_(first)
        ->Option.map(Re.captures)
        ->Option.mapWithDefault([], Utils.unwrapNullableArray)
      let id = result[1]->Option.map(int_of_string)
      switch id {
      | None => None
      | Some(id) =>
        Some({
          id: id,
          beacons: lines->Array2.map(parsePosition)->Utils.unwrapOptionArray,
        })
      }
    }
  }
}

let cos_ = a =>
  switch mod(a, 4) {
  | 0 => 1
  | 1 => 0
  | 2 => -1
  | 3 => 0
  | _ => Js.Exn.raiseError("wat")
  }

let sin_ = a =>
  switch mod(a, 4) {
  | 0 => 0
  | 1 => 1
  | 2 => 0
  | 3 => -1
  | _ => Js.Exn.raiseError("wat")
  }

let rotateBeacon = ((x, y, z): position, rx: int, ry: int, rz: int) => {
  let x1 = x
  let y1 = y * cos_(rx) - z * sin_(rx)
  let z1 = y * sin_(rx) + z * cos_(rx)

  let x2 = x1 * cos_(ry) + z1 * sin_(ry)
  let y2 = y1
  let z2 = -x1 * sin_(ry) + z1 * cos_(ry)

  let x3 = x2 * cos_(rz) - y2 * sin_(rz)
  let y3 = x2 * sin_(rz) + y2 * cos_(rz)
  let z3 = z2

  (x3, y3, z3)
}

let rotateBeacons = (beacons: beacons, rx: int, ry: int, rz: int) =>
  beacons->Js.Array2.map(rotateBeacon(_, rx, ry, rz))

let allRotations: (position, (int, int, int) => 'a) => array<'a> = ((x, y, z), f) => [
  f(x, y, z),
  f(z, y, -x),
  f(-x, y, -z),
  f(-z, y, x),
  f(-y, x, z),
  f(z, x, y),
  f(y, x, -z),
  f(-z, x, -y),
  f(y, -x, z),
  f(z, -x, -y),
  f(-y, -x, -y),
  f(-z, -x, y),
  f(x, -z, y),
  f(y, -z, -x),
  f(-x, -z, -y),
  f(-y, -x, z),
  f(x, -y, -z),
  f(-z, -y, -x),
  f(-x, -y, z),
  f(z, -y, x),
  f(x, z, -y),
  f(-y, z, -x),
  f(-x, z, y),
  f(y, z, x),
]

let matchingBeacons = ({beacons: a}: scanner, {beacons: b}: scanner) => {
  // open Js
  // open! Belt

  // a->Array2.map(p => p->allRotations((x,y,z) => ))
  Js.log2(a, b)

  []
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let scanners = inpt->String2.split("\n\n")->Array2.map(parseScanner)->Utils.unwrapOptionArray
  let first = scanners[0]->Option.getUnsafe
  let second = scanners[1]->Option.getUnsafe
  matchingBeacons(first, second)
}
