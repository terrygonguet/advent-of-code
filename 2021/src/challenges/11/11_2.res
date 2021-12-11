module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = ((a0, a1), (b0, b1)) =>
    switch Pervasives.compare(a0, b0) {
    | 0 => Pervasives.compare(a1, b1)
    | c => c
    }
})

let aboveNine = (grid: array<array<int>>) =>
  grid->Grid.reducexy(
    (set, n, x, y) => n > 9 ? set->Belt.Set.add((x, y)) : set,
    Belt.Set.make(~id=module(PairComparator)),
  )

let stringify = (grid: array<array<int>>) =>
  grid
  ->Js.Array2.map(line => line->Js.Array2.map(Belt.Int.toString)->Js.Array2.joinWith(""))
  ->Js.Array2.joinWith("\n")

let step = (grid: array<array<int>>) => {
  open! Belt

  let next = grid->Grid.map(n => n + 1)
  let flashed = MutableSet.make(~id=module(PairComparator))

  while aboveNine(next)->Set.size != flashed->MutableSet.size {
    let toFlash = MutableSet.make(~id=module(PairComparator))
    next->Grid.forEachxy((n, x, y) =>
      if n > 9 && !(flashed->MutableSet.has((x, y))) {
        toFlash->MutableSet.add((x, y))
      }
    )
    toFlash->MutableSet.forEach(((x, y)) => {
      next->Grid.update(x + 1, y, n => n + 1)->ignore
      next->Grid.update(x - 1, y, n => n + 1)->ignore
      next->Grid.update(x + 1, y + 1, n => n + 1)->ignore
      next->Grid.update(x, y + 1, n => n + 1)->ignore
      next->Grid.update(x - 1, y + 1, n => n + 1)->ignore
      next->Grid.update(x + 1, y - 1, n => n + 1)->ignore
      next->Grid.update(x, y - 1, n => n + 1)->ignore
      next->Grid.update(x - 1, y - 1, n => n + 1)->ignore
    })
    toFlash->MutableSet.forEach(pos => flashed->MutableSet.add(pos))
  }
  flashed->MutableSet.forEach(((x, y)) => next->Grid.set(x, y, 0)->ignore)

  (next, flashed->MutableSet.size)
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let grid = ref(
    inpt
    ->String2.split("\n")
    ->Array2.map(line => line->String2.split("")->Array2.map(int_of_string)),
  )
  let allFlashed = ref(false)
  let i = ref(0)

  while !allFlashed.contents {
    let (next, flashes) = step(grid.contents)
    grid := next
    allFlashed := flashes == next->Grid.size
    incr(i)
  }

  i.contents
}
