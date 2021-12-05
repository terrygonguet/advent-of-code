@@warning("-8")
open Js
open! Belt

type vent = (int, int, int, int)

let parse: string => vent = str => {
  let parts = str->String2.split(" -> ")
  if parts->Array2.length != 2 {
    raise(invalid_arg("Invalid vent: " ++ str))
  }
  let coords = parts->Utils.flatMap(pt => pt->String2.split(",")->Array2.map(int_of_string))
  if coords->Array2.length != 4 {
    raise(invalid_arg("Invalid vent: " ++ str))
  }
  let [x1, y1, x2, y2] = coords
  (x1, y1, x2, y2)
}

let isCardinal = ((x1, y1, x2, y2): vent) => x1 == x2 || y1 == y2

let trace = ((x1, y1, x2, y2): vent) => {
  let horizontal = y1 == y2
  let vertical = x1 == x2
  let points: array<(int, int)> = []

  switch (horizontal, vertical) {
  | (false, false) => points
  | (true, false) => {
      for i in min(x1, x2) to max(x1, x2) {
        points->Array2.push((i, y1))->ignore
      }
      points
    }
  | (false, true) => {
      for i in min(y1, y2) to max(y1, y2) {
        points->Array2.push((x1, i))->ignore
      }
      points
    }
  | (true, true) => points
  }
}

let includes = ((x1, y1, x2, y2): vent, (x, y): (int, int)) => {
  if x > max(x1, x2) || x < min(x1, x2) || y > max(y1, y2) || y < min(y1, y2) {
    false
  } else {
    // http://www.sunshine2k.de/coding/java/PointOnLine/PointOnLine.html
    let dx = x2 - x1
    let dy = y2 - y1
    let slope = dx != 0 ? dy / dx : 2 // 2 means vertical slope

    switch slope {
    | -1 => y1 + x1 == y + x
    | 0 => y1 == y
    | 1 => y1 - x1 == y - x
    | 2 => x1 == x
    | _ => false
    }
  }
}
