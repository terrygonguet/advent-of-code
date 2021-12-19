@@warning("-8")

type rec pair = Constant(int) | Pair(pair, pair)
and token = Open | Close | Comma | Literal(int) | Value(pair)

let tokenize: string => array<token> = str =>
  str
  ->Js.String2.split("")
  ->Js.Array2.map(char =>
    switch char {
    | "[" => Open
    | "]" => Close
    | "," => Comma
    | _ =>
      switch Belt.Int.fromString(char) {
      | Some(n) => Literal(n)
      | None => Js.Exn.raiseError("Found invalid character '" ++ char ++ "'")
      }
    }
  )

let stringify = (pair: array<token>) =>
  pair
  ->Js.Array2.map(token =>
    switch token {
    | Open => "["
    | Close => "]"
    | Comma => ","
    | Literal(n) => Belt.Int.toString(n)
    | Value(_) => "??"
    }
  )
  ->Js.Array2.joinWith("")

let findIndexOfLiteralFrom = (pair: array<token>, ~from: int) => {
  let result = ref(None)
  let index = ref(from)
  while result.contents->Belt.Option.isNone && index.contents < pair->Js.Array2.length {
    let i = index.contents
    switch pair[i] {
    | Literal(_) => result := Some(i)
    | _ => ()
    }
    incr(index)
  }
  result.contents
}

let rec reduce = (pair: array<token>) => {
  let depth = ref(0)
  let lastLiteral = ref(-1)
  let index = ref(0)
  let didSomething = ref(false)
  while index.contents < pair->Js.Array2.length && !didSomething.contents {
    let i = index.contents
    let token = pair->Belt.Array.getUnsafe(i)
    switch token {
    | Open => incr(depth)
    | Close => decr(depth)
    | Literal(_) => lastLiteral := i
    | _ => ()
    }
    if depth.contents == 5 {
      //   Js.log("----------------")
      //   Js.log2("from", pair->stringify)
      let (a, b) = switch pair->Js.Array2.slice(~start=i, ~end_=i + 5) {
      | [Open, Literal(a), Comma, Literal(b), Close] => (a, b)
      | _ => Js.Exn.raiseError("well shit then")
      }
      switch pair->Belt.Array.get(lastLiteral.contents) {
      | Some(Literal(n)) => pair->Belt.Array.setUnsafe(lastLiteral.contents, Literal(n + a))
      | _ => ()
      }
      switch pair->findIndexOfLiteralFrom(~from=i + 5) {
      | Some(i) => {
          let Literal(n) = pair->Belt.Array.getUnsafe(i)
          pair->Belt.Array.setUnsafe(i, Literal(n + b))
        }
      | _ => ()
      }
      pair->Js.Array2.spliceInPlace(~pos=i, ~remove=5, ~add=[Literal(0)])->ignore
      //   Js.log2("to  ", pair->stringify)
      didSomething := true
    }
    incr(index)
  }
  index := 0
  while index.contents < pair->Js.Array2.length && !didSomething.contents {
    let i = index.contents
    switch pair->Belt.Array.getUnsafe(i) {
    | Literal(n) if n > 9 => {
        // Js.log("----------------")
        // Js.log2("from", pair->stringify)
        let a = n / 2
        let b = ceil(n->Js.Int.toFloat /. 2.0)
        pair
        ->Js.Array2.spliceInPlace(
          ~pos=i,
          ~remove=1,
          ~add=[Open, Literal(a), Comma, Literal(b->Belt.Float.toInt), Close],
        )
        ->ignore
        // Js.log2("to  ", pair->stringify)
        didSomething := true
      }
    | _ => ()
    }
    incr(index)
  }
  didSomething.contents ? reduce(pair) : pair
}

/* 



    switch token {

    | Literal(n) if n > 9 => {

        Js.log("----------------")

        Js.log2("from", pair->stringify)

        let a = n / 2

        let b = ceil(n->Js.Int.toFloat /. 2.0)

        pair

        ->Js.Array2.spliceInPlace(

          ~pos=i,

          ~remove=1,

          ~add=[Open, Literal(a), Comma, Literal(b->Belt.Float.toInt), Close],

        )

        ->ignore

        Js.log2("to  ", pair->stringify)

        didSomething := true

      }

    | _ => ()

    }

	*/

let add = (a: array<token>, b: array<token>) =>
  reduce(
    [Open]
    ->Js.Array2.concat(a)
    ->Js.Array2.concat([Comma])
    ->Js.Array2.concat(b)
    ->Js.Array2.concat([Close]),
  )

let parse: array<token> => option<pair> = tokens => {
  let clone = tokens->Belt.Array.sliceToEnd(0)
  while clone->Js.Array2.length > 1 {
    let index = ref(0)
    let didSomething = ref(false)
    while index.contents < clone->Js.Array2.length && !didSomething.contents {
      let i = index.contents
      incr(index)
      switch clone->Js.Array2.slice(~start=i, ~end_=i + 5) {
      | [Open, Value(a), Comma, Value(b), Close] => {
          clone->Js.Array2.spliceInPlace(~pos=i, ~remove=5, ~add=[Value(Pair(a, b))])->ignore
          didSomething := true
        }
      | [Literal(n), _, _, _, _]
      | [Literal(n), _, _, _]
      | [Literal(n), _, _]
      | [Literal(n), _]
      | [Literal(n)] => {
          clone->Js.Array2.spliceInPlace(~pos=i, ~remove=1, ~add=[Value(Constant(n))])->ignore
          didSomething := true
        }
      | _ => ()
      }
    }
  }

  switch clone->Js.Array2.shift {
  | Some(Value(pair)) => Some(pair)
  | _ => None
  }
}

let rec magnitude = (pair: pair) =>
  switch pair {
  | Constant(n) => n
  | Pair(a, b) => 3 * magnitude(a) + 2 * magnitude(b)
  }

let default = (inpt: string) => {
  open Js
  open! Belt

  let numbers = inpt->String2.split("\n")->Array2.map(tokenize)
  let pairs =
    numbers->Utils.flatMap(a => numbers->Utils.flatMap(b => a === b ? [] : [(a, b), (b, a)]))
  let scores = pairs->Array2.map(((a, b)) => add(a, b)->parse->Option.mapWithDefault(0, magnitude))
  scores->Array2.sortInPlaceWith((a, b) => b - a)
}
