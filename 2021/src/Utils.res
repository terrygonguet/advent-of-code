@send external flatMap: (array<'a>, 'a => array<'b>) => array<'b> = "flatMap"

let getOrDefault = (arr: array<'a>, i: int, defaultValue: 'a) =>
  arr->Belt.Array.get(i) |> Js.Option.getWithDefault(defaultValue)

let logAndPass = (thing: 'a) => {
  Js.log(thing)
  thing
}

let last = (arr: array<'a>) =>
  switch arr->Js.Array2.length {
  | 0 => None
  | n => arr->Belt.Array.get(n - 1)
  }

@send external padStart: (string, int, string) => string = "padStart"
@send external padEnd: (string, int, string) => string = "padEnd"
