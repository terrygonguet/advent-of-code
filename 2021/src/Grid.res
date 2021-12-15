type t<'a> = array<array<'a>>

let mapxy = (grid: t<'a>, f: ('a, int, int) => 'b) =>
  grid->Js.Array2.mapi((line, y) => line->Js.Array2.mapi((n, x) => f(n, x, y)))

let map = (grid: t<'a>, f: 'a => 'b) => grid->Js.Array2.map(line => line->Js.Array2.map(f))

let forEachxy = (grid: t<'a>, f: ('a, int, int) => 'b) =>
  grid->Js.Array2.forEachi((line, y) => line->Js.Array2.forEachi((n, x) => f(n, x, y)))

let forEach = (grid: t<'a>, f: 'a => 'b) =>
  grid->Js.Array2.forEach(line => line->Js.Array2.forEach(f))

let unsafe_get = (grid: t<'a>, x: int, y: int) => grid[y][x]

let get = (grid: t<'a>, x: int, y: int) =>
  grid->Belt.Array.get(y)->Belt.Option.flatMap(line => line->Belt.Array.get(x))

let unsafe_set = (grid: t<'a>, x: int, y: int, value: 'a) =>
  switch grid->Belt.Array.get(y) {
  | Some(line) => line->Js.Array2.unsafe_set(x, value)
  | None => ()
  }

let set = (grid: t<'a>, x: int, y: int, value: 'a) =>
  switch grid->Belt.Array.get(y) {
  | Some(line) => line->Belt.Array.set(x, value)
  | None => false
  }

let update = (grid: t<'a>, x: int, y: int, f: 'a => 'a) =>
  switch grid->Belt.Array.get(y) {
  | Some(line) =>
    switch line->Belt.Array.get(x) {
    | Some(n) => line->Belt.Array.set(x, f(n))
    | None => false
    }

  | None => false
  }

let some = (grid: t<'a>, f: 'a => bool) => grid->Js.Array2.some(line => line->Js.Array2.some(f))

let reducexy = (grid: t<'a>, f: ('b, 'a, int, int) => 'b, initial: 'b) =>
  grid->Js.Array2.reducei(
    (acc, line, y) => line->Js.Array2.reducei((acc, n, x) => f(acc, n, x, y), acc),
    initial,
  )

let size = (grid: t<'a>) => grid->Js.Array2.reduce((sum, line) => sum + line->Js.Array2.length, 0)

let dimensions = (grid: t<'a>) => (
  grid->Js.Array2.reduce((acc, line) => max(acc, line->Js.Array2.length), 0),
  grid->Js.Array2.length,
)

let makeBy = (w: int, h: int, f: (int, int) => 'a) =>
  Belt.Array.makeBy(h, y => Belt.Array.makeBy(w, x => f(x, y)))

let stringifyBy = (grid: t<'a>, f: 'a => string) =>
  grid
  ->Js.Array2.map(line => line->Js.Array2.map(f)->Js.Array2.joinWith(""))
  ->Js.Array2.joinWith("\n")
