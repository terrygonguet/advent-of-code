open NodeJs.Process
open Belt
open Belt.Option

type solutionModule = {default: string => string}

@val
external esImport: string => Js.Promise.t<'a> = "import"

type buffer
@module("fs/promises") external readFile: string => Js.Promise.t<buffer> = "readFile"
@send external bufferToString: buffer => string = "toString"

let args = process->argv
let day = args->Array.get(2)->flatMap(Int.fromString)->getWithDefault(1)
let part = args->Array.get(3)->flatMap(Int.fromString)->getWithDefault(1)
let file = args->Array.get(4)->getWithDefault("puzzle")

if day < 1 || day > 25 {
  Js.Exn.raiseRangeError(
    `Day argument must be between 1 and 25 included, got ${day->Int.toString}.`,
  )
}
if part < 1 || part > 2 {
  Js.Exn.raiseRangeError(
    `Range argument must be between 1 and 2 included, got ${part->Int.toString}.`,
  )
}

let loadChallenge = (~day=1, ~file="puzzle", ()) => {
  open Js.Promise

  // "absolute" path of a file to use with raw fs API
  let path = "./src/challenges/" ++ day->Int.toString ++ "/" ++ file ++ ".txt"
  readFile(path) |> then_(buffer => buffer->bufferToString->resolve)
}

let loadSolution = (~day=1, ~part=1, ()) => {
  open Js.Promise

  // "relative" path for es6 `import()`
  let path =
    "./challenges/" ++
    day->Int.toString ++
    "/" ++
    day->Int.toString ++
    "_" ++
    part->Int.toString ++ ".bs.js"
  esImport(path) |> then_(({default: solution}) => resolve(solution))
}

let solveChallenge = (~day=1, ~part=1, ~file="puzzle", ()) => {
  open Js.Promise
  Js.log("Solving day " ++ day->Int.toString ++ " part " ++ part->Int.toString)

  let challenge: ref<string> = ref("")

  loadChallenge(~day, ~file, ())
  |> then_(challenge_ => {
    challenge := challenge_
    loadSolution(~day, ~part, ())
  })
  |> then_(solution => solution(challenge.contents)->resolve)
  |> then_(result => Js.log(result)->resolve)
  |> catch(err => Js.log(err)->resolve)
  |> ignore
}

solveChallenge(~day, ~part, ~file, ())
