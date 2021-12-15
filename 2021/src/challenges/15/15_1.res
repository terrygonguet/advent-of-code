let default = (inpt: string) => {
  open Js
  open! Belt

  let grid =
    inpt
    ->String2.split("\n")
    ->Array2.map(line => line->String2.split("")->Array2.map(int_of_string))
  let (maxx, maxy) = grid->Grid.dimensions

  switch grid->AStar.findPathBetween((0, 0), (maxx - 1, maxy - 1)) {
  | Some(path) =>
    path
    ->Array2.map(((x, y)) => grid->Grid.unsafe_get(x, y))
    ->Array2.reduce((acc, cur) => acc + cur, 0) - grid->Grid.unsafe_get(0, 0)
  | None => 0
  }
}
