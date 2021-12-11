let mapxy = (grid: array<array<'a>>, f: ('a, int, int) => 'b) =>
  grid->Js.Array2.mapi((line, y) => line->Js.Array2.mapi((n, x) => f(n, x, y)))

let map = (grid: array<array<'a>>, f: 'a => 'b) =>
  grid->Js.Array2.map(line => line->Js.Array2.map(f))

let forEachxy = (grid: array<array<'a>>, f: ('a, int, int) => 'b) =>
  grid->Js.Array2.forEachi((line, y) => line->Js.Array2.forEachi((n, x) => f(n, x, y)))

let forEach = (grid: array<array<'a>>, f: 'a => 'b) =>
  grid->Js.Array2.forEach(line => line->Js.Array2.forEach(f))

let unsafe_set = (grid: array<array<'a>>, x: int, y: int, value: 'a) =>
  switch grid->Belt.Array.get(y) {
  | Some(line) => line->Js.Array2.unsafe_set(x, value)
  | None => ()
  }

let set = (grid: array<array<'a>>, x: int, y: int, value: 'a) =>
  switch grid->Belt.Array.get(y) {
  | Some(line) => line->Belt.Array.set(x, value)
  | None => false
  }

let update = (grid: array<array<'a>>, x: int, y: int, f: 'a => 'a) =>
  switch grid->Belt.Array.get(y) {
  | Some(line) =>
    switch line->Belt.Array.get(x) {
    | Some(n) => line->Belt.Array.set(x, f(n))
    | None => false
    }

  | None => false
  }

let some = (grid: array<array<'a>>, f: 'a => bool) =>
  grid->Js.Array2.some(line => line->Js.Array2.some(f))

let reducexy = (grid: array<array<'a>>, f: ('b, 'a, int, int) => 'b, initial: 'b) =>
  grid->Js.Array2.reducei(
    (acc, line, y) => line->Js.Array2.reducei((acc, n, x) => f(acc, n, x, y), acc),
    initial,
  )

let size = (grid: array<array<'a>>) =>
  grid->Js.Array2.reduce((sum, line) => sum + line->Js.Array2.length, 0)
