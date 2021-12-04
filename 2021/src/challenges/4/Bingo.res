open Js
open! Belt

type board = array<array<(int, bool)>>

external unsafe_make: array<array<(int, bool)>> => board = "%identity"

let parse: string => board = str => {
  let lines =
    str
    ->String2.replaceByRe(%re("/ +/g"), " ")
    ->String2.split("\n")
    ->Array2.map(line => line->String2.trim->String2.split(" "))
    ->Array2.map(line =>
      line->Array2.map(n => (Int.fromString(n)->Option.getWithDefault(0), false))
    )

  lines
}

let isWon = (board: board) => {
  board->Array2.some(row => row->Array2.every(((_, checked)) => checked)) ||
    board
    ->Array2.reduce(
      (acc, cur) =>
        acc->Array2.filter(i =>
          cur[i]->Option.map(((_, checked)) => checked)->Option.getWithDefault(false)
        ),
      Array.makeBy(5, i => i),
    )
    ->Array2.length > 0
}

let tick: (board, int) => board = (board, roll) => {
  board->Array2.map(line => line->Array2.map(((n, checked)) => (n, checked || n == roll)))
}

let score = (board: board) => {
  board->Array2.reduce(
    (acc, cur) => acc + cur->Array2.reduce((acc, (n, checked)) => acc + (checked ? 0 : n), 0),
    0,
  )
}
