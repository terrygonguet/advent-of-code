type gameState = {
  mutable p1score: int,
  mutable p2score: int,
  mutable p1pos: int,
  mutable p2pos: int,
  mutable die: int,
  mutable turn: int,
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let lines =
    inpt
    ->String2.split("\n")
    ->Array2.map(line =>
      line->String2.split("")->Utils.last->Option.mapWithDefault(0, int_of_string)
    )
  let (startP1, startP2) = switch lines {
  | [a, b] => (a, b)
  | _ => Exn.raiseError("Invalid input")
  }

  let state = {
    p1score: 0,
    p2score: 0,
    p1pos: startP1 - 1,
    p2pos: startP2 - 1,
    die: 0,
    turn: 0,
  }
  while state.p1score < 1000 && state.p2score < 1000 {
    let r1 = mod(state.die + 1, 100)
    let r2 = mod(state.die + 2, 100)
    let r3 = mod(state.die + 3, 100)
    state.die = state.die + 3
    let move = r1 + r2 + r3
    if mod(state.turn, 2) == 0 {
      state.p1pos = mod(state.p1pos + move, 10)
      state.p1score = state.p1score + state.p1pos + 1
    } else {
      state.p2pos = mod(state.p2pos + move, 10)
      state.p2score = state.p2score + state.p2pos + 1
    }
    state.turn = state.turn + 1
  }

  (state.p1score >= 1000 ? state.p2score : state.p1score) * state.die
}
