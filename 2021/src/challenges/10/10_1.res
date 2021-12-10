type token =
  | OpenRound
  | OpenSquare
  | OpenCurly
  | OpenAngle
  | CloseRound
  | CloseSquare
  | CloseCurly
  | CloseAngle
type parseError =
  UnexpectedRound | UnexpectedSquare | UnexpectedCurly | UnexpectedAngle | UnexpectedEOL
type parseResult = Belt.Result.t<array<token>, parseError>
type block = Round | Square | Curly | Angle

let parseLine: string => parseResult = line => {
  open Js
  open! Belt

  let tokens = Array2.fromMap(line->String2.castToArrayLike, char =>
    switch char {
    | "(" => OpenRound
    | "[" => OpenSquare
    | "{" => OpenCurly
    | "<" => OpenAngle
    | ")" => CloseRound
    | "]" => CloseSquare
    | "}" => CloseCurly
    | ">" => CloseAngle
    | _ => Exn.raiseError("Invalid character \"" ++ char ++ "\" found.")
    }
  )

  let state: Result.t<array<block>, parseError> = Result.Ok([])

  if tokens->Array2.length == 0 {
    Result.Ok([])
  } else {
    let result = tokens->Array2.reduce((acc, cur) =>
        acc->Result.flatMap(stack => {
          let last = stack->Utils.last
          let len = stack->Array2.length - 1
          // %debugger
          switch cur {
          | OpenRound => Result.Ok(stack->Array2.concat([Round]))
          | OpenSquare => Result.Ok(stack->Array2.concat([Square]))
          | OpenAngle => Result.Ok(stack->Array2.concat([Angle]))
          | OpenCurly => Result.Ok(stack->Array2.concat([Curly]))
          | CloseRound if last == Some(Round) => Result.Ok(stack->Array.slice(~offset=0, ~len))
          | CloseSquare if last == Some(Square) => Result.Ok(stack->Array.slice(~offset=0, ~len))
          | CloseAngle if last == Some(Angle) => Result.Ok(stack->Array.slice(~offset=0, ~len))
          | CloseCurly if last == Some(Curly) => Result.Ok(stack->Array.slice(~offset=0, ~len))
          | CloseRound => Result.Error(UnexpectedRound)
          | CloseSquare => Result.Error(UnexpectedSquare)
          | CloseAngle => Result.Error(UnexpectedAngle)
          | CloseCurly => Result.Error(UnexpectedCurly)
          }
        })
      , state)->Result.flatMap(_ => Result.Error(UnexpectedEOL))

    result->Result.map(_ => tokens)
  }
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let lines = inpt->String2.split("\n")

  lines
  ->Array2.map(parseLine)
  ->Array2.map(line =>
    switch line {
    | Ok(_) => 0
    | Error(UnexpectedRound) => 3
    | Error(UnexpectedSquare) => 57
    | Error(UnexpectedCurly) => 1197
    | Error(UnexpectedAngle) => 25137
    | Error(UnexpectedEOL) => 0
    }
  )
  ->Array2.reduce((a, b) => a + b, 0)
}
