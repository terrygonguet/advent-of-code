let default = (inpt: string) => {
  open Js
  open! Belt

  let connections =
    inpt
    ->String2.split("\n")
    ->Array2.mapi((line, i) =>
      switch line->String2.split("-") {
      | [a, b] => (a, b)
      | _ => Exn.raiseError("Invalid connection \"" ++ line ++ "\" on line " ++ i->Int.toString)
      }
    )
  let graph = CaveGraph.make(connections)

  graph->CaveGraph.findAllPathsBetween("start", "end")->Utils.logAndPass->Array2.length
}
