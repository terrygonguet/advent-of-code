type block = Round | Square | Curly | Angle
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
  | UnexpectedRound
  | UnexpectedSquare
  | UnexpectedCurly
  | UnexpectedAngle
  | UnexpectedEOL(array<block>)
type parseResult = Belt.Result.t<array<token>, parseError>

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
      , state)->Result.flatMap(stack => Result.Error(UnexpectedEOL(stack)))

    result->Result.map(_ => tokens)
  }
}

let score = (blocks: array<block>) => {
  open! BigInt
  let bigFive = fromInt(5)
  blocks->Js.Array2.reduceRight((acc, cur) =>
    switch cur {
    | Round => add(mult(acc, bigFive), fromInt(1))
    | Square => add(mult(acc, bigFive), fromInt(2))
    | Curly => add(mult(acc, bigFive), fromInt(3))
    | Angle => add(mult(acc, bigFive), fromInt(4))
    }
  , zero)
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let lines = inpt->String2.split("\n")

  let scores =
    lines
    ->Array2.map(line =>
      switch parseLine(line) {
      | Ok(_) => BigInt.zero
      | Error(UnexpectedEOL(blocks)) => score(blocks)
      | _ => BigInt.zero
      }
    )
    ->Array2.filter(n => !BigInt.eq(n, BigInt.zero))
    ->Array2.sortInPlaceWith(BigInt.cmp)

  scores[scores->Array2.length / 2]
}
