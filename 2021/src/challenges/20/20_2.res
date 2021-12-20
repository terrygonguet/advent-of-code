module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = ((a0, a1), (b0, b1)) =>
    switch Pervasives.compare(a0, b0) {
    | 0 => Pervasives.compare(a1, b1)
    | c => c
    }
})

type grid = Belt.Map.t<PairComparator.t, int, PairComparator.identity>
let enhance = (grid: grid, alg: array<int>, ~outsideBit=0, ()) => {
  open Js
  open! Belt

  let (minx, miny) = switch grid->Map.minimum {
  | Some((k, _)) => k
  | None => (0, 0)
  }
  let (maxx, maxy) = switch grid->Map.maximum {
  | Some((k, _)) => k
  | None => (0, 0)
  }

  let enhanced = ref(Map.make(~id=module(PairComparator)))
  for x in minx - 1 to maxx + 1 {
    for y in miny - 1 to maxy + 1 {
      let digits =
        [
          (x - 1, y - 1),
          (x, y - 1),
          (x + 1, y - 1),
          (x - 1, y),
          (x, y),
          (x + 1, y),
          (x - 1, y + 1),
          (x, y + 1),
          (x + 1, y + 1),
        ]->Array2.map(Map.getWithDefault(grid, _, outsideBit))
      let addr = digits->Array2.reduce((acc, bit) => acc ++ bit->Int.toString, "0b")->int_of_string
      switch alg[addr] {
      | Some(bit) => enhanced := enhanced.contents->Map.set((x, y), bit)
      | None => Exn.raiseError("Can't get bit from alg at address" ++ addr->Int.toString)
      }
    }
  }

  enhanced.contents
}

let display = (grid: grid) => {
  open Js
  open! Belt

  let (minx, miny) = switch grid->Map.minimum {
  | Some((pos, _)) => pos
  | None => (0, 0)
  }
  let (maxx, maxy) = switch grid->Map.maximum {
  | Some((pos, _)) => pos
  | None => (0, 0)
  }
  let display = Grid.makeBy(maxx - minx + 1, maxy - miny + 1, (x, y) =>
    grid->Map.getWithDefault((x + minx, y + miny), 0)
  )

  Js.log("-"->String2.repeat(maxx - minx + 1))
  Js.log(display->Grid.stringifyBy(bit => bit == 1 ? `█` : " ")) // `██` : "  "))
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let blocks = inpt->String2.split("\n\n")
  let alg =
    blocks[0]
    ->Option.getExn
    ->String2.split("")
    ->Array2.map(char =>
      switch char {
      | "#" => 1
      | _ => 0
      }
    )
  let grid =
    blocks[1]
    ->Option.getExn
    ->String2.split("\n")
    ->Array2.map(line =>
      line
      ->String2.split("")
      ->Array2.map(char =>
        switch char {
        | "#" => 1
        | _ => 0
        }
      )
    )
    ->Grid.reducexy(
      (map, cell, x, y) => map->Map.set((x, y), cell),
      Map.make(~id=module(PairComparator)),
    )

  // https://tenor.com/view/spy-kids-lemme-zoom-in-on-that-zoom-watching-you-spy-gif-5212510
  let grid = ref(grid)
  for i in 0 to 49 {
    grid := grid.contents->enhance(alg, ~outsideBit=mod(i, 2), ())
  }
  grid.contents->display

  grid.contents->Map.reduce(0, (acc, _, v) => acc + v)
}
