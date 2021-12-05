@val external max3: ('a, 'a, 'a) => 'a = "Math.max"

let default = (inpt: string) => {
  open Js
  open! Belt

  let vents = inpt->String2.split("\n")->Array2.map(ThermalVent.parse)

  let maxx = vents->Array2.reduce((acc, (x1, _, x2, _)) => max3(acc, x1, x2), 0)
  let maxy = vents->Array2.reduce((acc, (_, y1, _, y2)) => max3(acc, y1, y2), 0)

  let crossings = ref(0)
  for x in 0 to maxx {
    for y in 0 to maxy {
      let i = ref(0)
      let n = ref(0)
      let pt = (x, y)
      while n.contents < 2 && i.contents < vents->Array2.length {
        let vent = vents[i.contents]->Option.getWithDefault((0, 0, 0, 0))
        if vent->ThermalVent.includes(pt) {
          n := n.contents + 1
        }
        i := i.contents + 1
      }
      crossings := crossings.contents + (n.contents >= 2 ? 1 : 0)
    }
  }
  crossings.contents
}
