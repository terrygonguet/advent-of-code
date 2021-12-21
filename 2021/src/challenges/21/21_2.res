module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int, int, int)
  let cmp = ((a0, a1, a2, a3), (b0, b1, b2, b3)) =>
    switch a0 - b0 {
    | 0 =>
      switch a1 - b1 {
      | 0 =>
        switch a2 - b2 {
        | 0 => a3 - b3
        | c => c
        }
      | c => c
      }
    | c => c
    }
})

let multipliers = Belt.Map.Int.fromArray([
  (3, BigInt.one),
  (4, BigInt.fromInt(3)),
  (5, BigInt.fromInt(6)),
  (6, BigInt.fromInt(7)),
  (7, BigInt.fromInt(6)),
  (8, BigInt.fromInt(3)),
  (9, BigInt.fromInt(1)),
])
let moveP1by = (multiverse, p1: int, p2: int, s1: int, s2: int, by: int, n: BigInt.t) => {
  let nextpos = mod(p1 + by, 10)
  let n = BigInt.mult(n, multipliers->Belt.Map.Int.getWithDefault(by, BigInt.one))
  if s1 + nextpos + 1 < 21 {
    (
      multiverse->Belt.Map.update((nextpos, p2, s1 + nextpos + 1, s2), prev =>
        switch prev {
        | None => Some(n)
        | Some(m) => Some(BigInt.add(m, n))
        }
      ),
      BigInt.zero,
    )
  } else {
    (multiverse, n)
  }
}
let moveP2by = (multiverse, p1: int, p2: int, s1: int, s2: int, by: int, n: BigInt.t) => {
  let nextpos = mod(p2 + by, 10)
  let n = BigInt.mult(n, multipliers->Belt.Map.Int.getWithDefault(by, BigInt.one))
  if s2 + nextpos + 1 < 21 {
    (
      multiverse->Belt.Map.update((p1, nextpos, s1, s2 + nextpos + 1), prev =>
        switch prev {
        | None => Some(n)
        | Some(m) => Some(BigInt.add(m, n))
        }
      ),
      BigInt.zero,
    )
  } else {
    (multiverse, n)
  }
}
let moveP1 = (multiverse, p1: int, p2: int, s1: int, s2: int, n: BigInt.t) => {
  let (multiverse, w1) = multiverse->moveP1by(p1, p2, s1, s2, 3, n)
  let (multiverse, w2) = multiverse->moveP1by(p1, p2, s1, s2, 4, n)
  let (multiverse, w3) = multiverse->moveP1by(p1, p2, s1, s2, 5, n)
  let (multiverse, w4) = multiverse->moveP1by(p1, p2, s1, s2, 6, n)
  let (multiverse, w5) = multiverse->moveP1by(p1, p2, s1, s2, 7, n)
  let (multiverse, w6) = multiverse->moveP1by(p1, p2, s1, s2, 8, n)
  let (multiverse, w7) = multiverse->moveP1by(p1, p2, s1, s2, 9, n)
  let w = BigInt.add(w1, w2)
  let w = BigInt.add(w, w3)
  let w = BigInt.add(w, w4)
  let w = BigInt.add(w, w5)
  let w = BigInt.add(w, w6)
  let w = BigInt.add(w, w7)
  (multiverse, w)
}
let moveP2 = (multiverse, p1: int, p2: int, s1: int, s2: int, n: BigInt.t) => {
  let (multiverse, w1) = multiverse->moveP2by(p1, p2, s1, s2, 3, n)
  let (multiverse, w2) = multiverse->moveP2by(p1, p2, s1, s2, 4, n)
  let (multiverse, w3) = multiverse->moveP2by(p1, p2, s1, s2, 5, n)
  let (multiverse, w4) = multiverse->moveP2by(p1, p2, s1, s2, 6, n)
  let (multiverse, w5) = multiverse->moveP2by(p1, p2, s1, s2, 7, n)
  let (multiverse, w6) = multiverse->moveP2by(p1, p2, s1, s2, 8, n)
  let (multiverse, w7) = multiverse->moveP2by(p1, p2, s1, s2, 9, n)
  let w = BigInt.add(w1, w2)
  let w = BigInt.add(w, w3)
  let w = BigInt.add(w, w4)
  let w = BigInt.add(w, w5)
  let w = BigInt.add(w, w6)
  let w = BigInt.add(w, w7)
  (multiverse, w)
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

  let multiverse = ref(
    Map.fromArray(~id=module(PairComparator), [((startP1 - 1, startP2 - 1, 0, 0), BigInt.one)]),
  )
  let p1wins = ref(BigInt.zero)
  let p2wins = ref(BigInt.zero)
  let turn = ref(0)
  while multiverse.contents->Map.size > 0 {
    multiverse :=
      multiverse.contents->Map.reduce(Map.make(~id=module(PairComparator)), (
        acc,
        (p1, p2, s1, s2),
        n,
      ) =>
        if mod(turn.contents, 2) == 0 {
          let (acc, w) = acc->moveP1(p1, p2, s1, s2, n)
          p1wins := BigInt.add(p1wins.contents, w)
          acc
        } else {
          let (acc, w) = acc->moveP2(p1, p2, s1, s2, n)
          p2wins := BigInt.add(p2wins.contents, w)
          acc
        }
      )
    incr(turn)
  }

  (p1wins.contents, p2wins.contents)
}
