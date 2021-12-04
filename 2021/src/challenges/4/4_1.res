exception InvalidInput(string)

let default = (inpt: string) => {
  open Js
  open! Belt

  let blocks = inpt->String2.split("\n\n")
  let rolls =
    blocks
    ->Array.get(0)
    ->Option.map(str =>
      str->String2.split(",")->Array2.map(n => Int.fromString(n)->Option.getWithDefault(0))
    )
    ->Option.getWithDefault(Array.make(0, 0))
  let boards: ref<array<Bingo.board>> = ref([])
  boards := blocks->Array.slice(~offset=1, ~len=blocks->Array2.length - 1)->Array2.map(Bingo.parse)

  let lastRoll = ref(0)
  while !(boards.contents->Array2.some(Bingo.isWon)) {
    let roll = switch rolls->Array2.shift {
    | Some(n) => n
    | None => raise(InvalidInput("We ran out of rolls!"))
    }
    lastRoll := roll
    boards := boards.contents->Array2.map(Bingo.tick(_, roll))
  }

  boards.contents
  ->Array2.filter(Bingo.isWon)
  ->Array2.map(board => Bingo.score(board) * lastRoll.contents)
}
