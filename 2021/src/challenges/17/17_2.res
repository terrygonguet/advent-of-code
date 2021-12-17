type target = {x: (int, int), y: (int, int)}

let parseTarget = (str: string) => {
  let re = Js.Re.fromString("target area: x=(-?\\d+)\\.\\.(-?\\d+), y=(-?\\d+)\\.\\.(-?\\d+)")

  re
  ->Js.Re.exec_(str)
  ->Belt.Option.map(Js.Re.captures)
  ->Belt.Option.map(matches =>
    matches->Js.Array2.map(Js.Nullable.toOption)->Utils.unwrapOptionArray
  )
  ->Belt.Option.flatMap(matches =>
    switch matches {
    | [_, x1, x2, y1, y2] => {
        let x1 = int_of_string(x1)
        let x2 = int_of_string(x2)
        let y1 = int_of_string(y1)
        let y2 = int_of_string(y2)
        Some({
          x: (min(x1, x2), max(x1, x2)),
          y: (min(y1, y2), max(y1, y2)),
        })
      }
    | _ => None
    }
  )
}

let evaluateTrajectory = (trajectory: (int, int), target: target) => {
  let {x: (x1, x2), y: (y1, y2)} = target

  let done = ref(false)
  let valid = ref(false)
  let pos = ref((0, 0))
  let vel = ref(trajectory)

  while !done.contents {
    let (x, y) = pos.contents
    let (vx, vy) = vel.contents
    valid := x >= x1 && x <= x2 && y >= y1 && y <= y2
    done := valid.contents || x > x2 || y < y1
    pos := (x + vx, y + vy)
    vel := (max(0, vx - 1), vy - 1)
  }

  (valid.contents, trajectory)
}

let computeTrajectories = (target: target) => {
  let {x: (x1, x2), y: (y1, y2)} = target

  let xcandidates = Belt.MutableSet.Int.make()
  for vel in 1 to x2 {
    let x = ref(0)
    for i in vel downto 0 {
      x := x.contents + i
      if x.contents >= x1 && x.contents <= x2 {
        xcandidates->Belt.MutableSet.Int.add(vel)
      }
    }
  }

  let ycandidates = Belt.MutableSet.Int.make()
  for vel in y1 to abs(y1 * 2) {
    let y = ref(0)
    for i in vel downto y1 {
      y := y.contents + i
      if y.contents >= y1 && y.contents <= y2 {
        ycandidates->Belt.MutableSet.Int.add(vel)
      }
    }
  }

  let xarr = xcandidates->Belt.MutableSet.Int.toArray
  let yarr = ycandidates->Belt.MutableSet.Int.toArray
  let candidates = xarr->Utils.flatMap(x => yarr->Js.Array2.map(y => (x, y)))

  candidates
  ->Js.Array2.map(candidate => candidate->evaluateTrajectory(target))
  ->Js.Array2.filter(((valid, _)) => valid)
  ->Js.Array2.map(((_, trajectory)) => trajectory)
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let trajectories =
    inpt
    ->String2.split("\n")
    ->Array2.map(parseTarget)
    ->Utils.unwrapOptionArray
    ->Array2.map(computeTrajectories)
    ->Array2.map(Array2.length)

  trajectories
}
