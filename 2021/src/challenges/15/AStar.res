type position = (int, int)
type path = array<position>

module PairComparator = Belt.Id.MakeComparable({
  type t = (int, int)
  let cmp = ((a0, a1), (b0, b1)) =>
    switch Pervasives.compare(a0, b0) {
    | 0 => Pervasives.compare(a1, b1)
    | c => c
    }
})

let dequeue = (queue: Belt.MutableMap.t<PairComparator.t, int, PairComparator.identity>) => {
  if queue->Belt.MutableMap.isEmpty {
    None
  } else {
    let (_, pos) =
      queue->Belt.MutableMap.reduce((Js.Int.max, (0, 0)), ((prio, pos), key, cur) =>
        cur < prio ? (cur, key) : (prio, pos)
      )
    queue->Belt.MutableMap.remove(pos)
    Some(pos)
  }
}

let getNeighbours = (grid: Grid.t<'a>, (x, y): position) => {
  let (maxx, maxy) = grid->Grid.dimensions
  let neighbours = [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
  neighbours->Js.Array2.filter(((x, y)) => x >= 0 && x < maxx && y >= 0 && y < maxy)
}

let heuristic = ((x1, y1): position, (x2, y2): position) => abs(x1 - x2) + abs(y1 - y2)

let findPathBetween: (Grid.t<'a>, position, position) => option<path> = (grid, start, end) => {
  open Js
  open! Belt

  let frontier = MutableMap.make(~id=module(PairComparator))
  frontier->MutableMap.set(start, 0)
  let came_from = MutableMap.make(~id=module(PairComparator))
  let cost_so_far = MutableMap.make(~id=module(PairComparator))
  cost_so_far->MutableMap.set(start, 0)

  let done = ref(false)
  while !done.contents {
    let current = frontier->dequeue->Option.getExn

    if current == end {
      done := true
    } else {
      let neighbours = grid->getNeighbours(current)
      let cost_to_current = cost_so_far->MutableMap.getWithDefault(current, 0)
      neighbours->Array2.forEach(next => {
        let (x, y) = next
        let new_cost = cost_to_current + grid->Grid.unsafe_get(x, y)
        if (
          cost_so_far->MutableMap.has(next)->not || new_cost < cost_so_far->MutableMap.getExn(next)
        ) {
          cost_so_far->MutableMap.set(next, new_cost)
          let priority = new_cost + heuristic(next, end)
          frontier->MutableMap.set(next, priority)
          came_from->MutableMap.set(next, current)
        }
      })

      done := frontier->MutableMap.isEmpty
    }
  }

  let path = []
  let pos = ref(Some(end))
  while pos.contents->Option.isSome {
    let current = pos.contents->Option.getExn
    path->Array2.unshift(current)->ignore
    pos := came_from->MutableMap.get(current)
  }

  Some(path)
}
