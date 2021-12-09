module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = ((a0, a1), (b0, b1)) =>
    switch Pervasives.compare(a0, b0) {
    | 0 => Pervasives.compare(a1, b1)
    | c => c
    }
})

let computeBasinAt = (grid: array<array<int>>, pos: (int, int)) => {
  open Js
  open! Belt

  let checked = ref(Set.make(~id=module(PairComparator)))
  let toCheck = ref(Set.make(~id=module(PairComparator)))
  let total = ref(0)
  let h = grid->Array2.length
  let w = grid->Utils.getOrDefault(0, [])->Array2.length

  toCheck := toCheck.contents->Set.add(pos)

  while toCheck.contents->Set.size > 0 {
    // %debugger
    let checking = toCheck.contents->Set.toArray
    toCheck := Set.make(~id=module(PairComparator))
    for i in 0 to checking->Array2.length - 1 {
      let pos = checking[i]->Option.getExn
      checked := checked.contents->Set.add(pos)
      let (x, y) = pos
      if grid->Utils.getOrDefault(y, [])->Utils.getOrDefault(x, 0) < 9 {
        total := total.contents + 1
        if !(checked.contents->Set.has((x + 1, y))) && x < w - 1 {
          toCheck := toCheck.contents->Set.add((x + 1, y))
        }
        if !(checked.contents->Set.has((x - 1, y))) && x > 0 {
          toCheck := toCheck.contents->Set.add((x - 1, y))
        }
        if !(checked.contents->Set.has((x, y + 1))) && y < h - 1 {
          toCheck := toCheck.contents->Set.add((x, y + 1))
        }
        if !(checked.contents->Set.has((x, y - 1))) && y > 0 {
          toCheck := toCheck.contents->Set.add((x, y - 1))
        }
      }
    }
  }

  //   Js.log(checked.contents->Set.toArray)

  total.contents
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let grid =
    inpt
    ->String2.split("\n")
    ->Array2.map(line => Array2.fromMap(String2.castToArrayLike(line), int_of_string))

  let basins =
    grid->Array2.mapi((line, y) => line->Array2.mapi((_, x) => grid->computeBasinAt((x, y))))

  basins
  ->Utils.flatMap(a => a)
  ->Set.Int.fromArray
  ->Set.Int.toArray
  ->Array.slice(~offset=-3, ~len=3)
  ->Array2.reduce((a, b) => a * b, 1)
}
