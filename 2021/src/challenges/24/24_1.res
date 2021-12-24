type instruction =
  | Input(string)
  | AddVal(string, int)
  | AddVar(string, string)
  | MultVal(string, int)
  | MultVar(string, string)
  | DivVal(string, int)
  | DivVar(string, string)
  | ModVal(string, int)
  | ModVar(string, string)
  | EqVal(string, int)
  | EqVar(string, string)

let isVar = (str: string) =>
  switch str {
  | "w" | "x" | "y" | "z" => true
  | _ => false
  }

let isVarOrInt = (str: string) => isVar(str) || Belt.Int.fromString(str)->Belt.Option.isSome

let parseInstruction: string => option<instruction> = str =>
  switch str->Js.String2.split(" ") {
  | ["inp", a] if isVar(a) => Some(Input(a))
  | ["add", a, b] if isVar(a) && isVarOrInt(b) =>
    switch Belt.Int.fromString(b) {
    | Some(b) => Some(AddVal(a, b))
    | None => Some(AddVar(a, b))
    }
  | ["mul", a, b] if isVar(a) && isVarOrInt(b) =>
    switch Belt.Int.fromString(b) {
    | Some(b) => Some(MultVal(a, b))
    | None => Some(MultVar(a, b))
    }
  | ["div", a, b] if isVar(a) && isVarOrInt(b) =>
    switch Belt.Int.fromString(b) {
    | Some(b) => Some(DivVal(a, b))
    | None => Some(DivVar(a, b))
    }
  | ["mod", a, b] if isVar(a) && isVarOrInt(b) =>
    switch Belt.Int.fromString(b) {
    | Some(b) => Some(ModVal(a, b))
    | None => Some(ModVar(a, b))
    }
  | ["eql", a, b] if isVar(a) && isVarOrInt(b) =>
    switch Belt.Int.fromString(b) {
    | Some(b) => Some(EqVal(a, b))
    | None => Some(EqVar(a, b))
    }
  | _ => None
  }

let stringify = (instruction: instruction) =>
  switch instruction {
  | Input(a) => "Input(" ++ a ++ ")"
  | AddVal(a, b) => "Add(" ++ a ++ ", " ++ b->Belt.Int.toString ++ ")"
  | AddVar(a, b) => "Add(" ++ a ++ ", " ++ b ++ ")"
  | MultVal(a, b) => "Mult(" ++ a ++ ", " ++ b->Belt.Int.toString ++ ")"
  | MultVar(a, b) => "Mult(" ++ a ++ ", " ++ b ++ ")"
  | DivVal(a, b) => "Div(" ++ a ++ ", " ++ b->Belt.Int.toString ++ ")"
  | DivVar(a, b) => "Div(" ++ a ++ ", " ++ b ++ ")"
  | ModVal(a, b) => "Mod(" ++ a ++ ", " ++ b->Belt.Int.toString ++ ")"
  | ModVar(a, b) => "Mod(" ++ a ++ ", " ++ b ++ ")"
  | EqVal(a, b) => "Eq(" ++ a ++ ", " ++ b->Belt.Int.toString ++ ")"
  | EqVar(a, b) => "Eq(" ++ a ++ ", " ++ b ++ ")"
  }

let execute = (program: array<instruction>, input: array<int>) => {
  open Js
  open! Belt

  let instructions = program->Array.copy
  let input = input->Array.copy
  let vars = MutableMap.String.make()
  while instructions->Array2.length > 0 {
    let instruction = instructions->Array2.shift
    switch instruction {
    | Some(Input(a)) =>
      switch input->Array2.shift {
      | Some(n) => vars->MutableMap.String.set(a, n)
      | None => Exn.raiseError("Exhausted input!")
      }
    | Some(AddVal(a, b)) => {
        let n = vars->MutableMap.String.getWithDefault(a, 0)
        vars->MutableMap.String.set(a, n + b)
      }
    | Some(AddVar(a, b)) => {
        let m = vars->MutableMap.String.getWithDefault(a, 0)
        let n = vars->MutableMap.String.getWithDefault(b, 0)
        vars->MutableMap.String.set(a, m + n)
      }
    | Some(MultVal(a, b)) => {
        let n = vars->MutableMap.String.getWithDefault(a, 0)
        vars->MutableMap.String.set(a, n * b)
      }
    | Some(MultVar(a, b)) => {
        let m = vars->MutableMap.String.getWithDefault(a, 0)
        let n = vars->MutableMap.String.getWithDefault(b, 0)
        vars->MutableMap.String.set(a, m * n)
      }
    | Some(DivVal(a, b)) => {
        let n = vars->MutableMap.String.getWithDefault(a, 0)
        vars->MutableMap.String.set(a, n / b)
      }
    | Some(DivVar(a, b)) => {
        let m = vars->MutableMap.String.getWithDefault(a, 0)
        let n = vars->MutableMap.String.getWithDefault(b, 0)
        vars->MutableMap.String.set(a, m / n)
      }
    | Some(ModVal(a, b)) => {
        let n = vars->MutableMap.String.getWithDefault(a, 0)
        vars->MutableMap.String.set(a, mod(n, b))
      }
    | Some(ModVar(a, b)) => {
        let m = vars->MutableMap.String.getWithDefault(a, 0)
        let n = vars->MutableMap.String.getWithDefault(b, 0)
        vars->MutableMap.String.set(a, mod(m, n))
      }
    | Some(EqVal(a, b)) => {
        let n = vars->MutableMap.String.getWithDefault(a, 0)
        vars->MutableMap.String.set(a, n == b ? 1 : 0)
      }
    | Some(EqVar(a, b)) => {
        let m = vars->MutableMap.String.getWithDefault(a, 0)
        let n = vars->MutableMap.String.getWithDefault(b, 0)
        vars->MutableMap.String.set(a, m == n ? 1 : 0)
      }
    | None => ()
    }
  }

  vars
}

let default = (inpt: string) => {
  open Js
  open! Belt

  let instructions =
    inpt->String2.split("\n")->Array2.map(parseInstruction)->Utils.unwrapOptionArray

  //   Js.log("---")
  //   instructions->Array2.map(stringify)->Array2.joinWith("\n")->Js.log

  let isValid = ref(false)
  let serial = ref(BigInt.fromString("99999999999999"))
  while !isValid.contents && BigInt.cmp(serial.contents, BigInt.fromString("10000000000000")) > 0 {
    let input = serial.contents->BigInt.toString->String2.split("")->Array2.map(int_of_string)
    if !(input->Array2.includes(0)) {
      let result = instructions->execute(input)
      isValid := result->MutableMap.String.getWithDefault("z", -1) == 0
    }
    serial := BigInt.sub(serial.contents, BigInt.one)
  }

  BigInt.add(serial.contents, BigInt.one)
}
