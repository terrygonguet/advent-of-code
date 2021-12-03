exception InvalidInput(string)

let default = (inpt: string) => {
  let readings = inpt->Js.String2.split("\n")
  let readingLength = readings[0]->Js.String2.length
  let numReadings = readings->Js.Array2.length

  if readings->Js.Array2.some(r => r->Js.String2.length != readingLength) {
    raise(InvalidInput("One reading is not like the others"))
  }

  let counts =
    readings->Js.Array2.reduce(
      (acc, cur) => acc->Js.Array2.mapi((n, i) => n + (cur->Js.String2.charAt(i) == "1" ? 1 : 0)),
      Belt.Array.make(readingLength, 0),
    )
  let gamma_bin = "0b" ++ counts->Js.Array2.map(n => n / (numReadings / 2))->Js.Array2.joinWith("")
  let gamma = int_of_string(gamma_bin)
  let sigma = int_of_string("0b" ++ "1"->Js.String2.repeat(readingLength)) - gamma // 2'complement

  gamma->Js.Int.toString ++
  ", " ++
  sigma->Js.Int.toString ++
  " => " ++
  (gamma * sigma)->Js.Int.toString
}
