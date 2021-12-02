type instruction = Forward(int) | Up(int) | Down(int)

@@warning("-8")
let default = (inpt: string) => {
  let instructions =
    inpt
    ->Js.String2.split("\n")
    ->Js.Array2.map(line => line->Js.String2.split(" "))
    ->Js.Array2.map(line => {
      if line->Js.Array2.length != 2 {
        Js.Exn.raiseError("Invalid instruction: " ++ line->Js.Array2.joinWith(", "))
      }
      let [name, val] = line
      let n = val->Belt.Int.fromString->Belt.Option.getWithDefault(0)
      switch name {
      | "forward" => Forward(n)
      | "up" => Up(n)
      | "down" => Down(n)
      | _ => Js.Exn.raiseError("Invalid instruction: " ++ name ++ "(" ++ val ++ ")")
      }
    })

  let (x, depth) = instructions->Js.Array2.reduce(((x, depth), cur) =>
    switch cur {
    | Forward(n) => (x + n, depth)
    | Up(n) => (x, depth - n)
    | Down(n) => (x, depth + n)
    }
  , (0, 0))

  x->Js.Int.toString ++ ", " ++ depth->Js.Int.toString ++ " => " ++ (x * depth)->Js.Int.toString
}
