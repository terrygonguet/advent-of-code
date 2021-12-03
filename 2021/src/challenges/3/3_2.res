exception InvalidInput(string)

let o2rating = (readings: array<string>) => {
  let filtered = ref(readings)
  let counter = ref(0)

  while filtered.contents->Js.Array2.length > 1 {
    let i = counter.contents
    let numReadings = filtered.contents->Js.Array2.length
    let count =
      filtered.contents->Js.Array2.reduce(
        (acc, cur) => acc + (cur->Js.String2.charAt(i) == "1" ? 1 : 0),
        0,
      )
    filtered := if 2 * count >= numReadings {
        filtered.contents->Js.Array2.filter(reading => reading->Js.String2.charAt(i) == "1")
      } else {
        filtered.contents->Js.Array2.filter(reading => reading->Js.String2.charAt(i) == "0")
      }
    counter := i + 1
  }

  int_of_string("0b" ++ filtered.contents[0])
}

// copy pasta is faster lol
let co2rating = (readings: array<string>) => {
  let filtered = ref(readings)
  let counter = ref(0)

  while filtered.contents->Js.Array2.length > 1 {
    let i = counter.contents
    let numReadings = filtered.contents->Js.Array2.length
    let count =
      filtered.contents->Js.Array2.reduce(
        (acc, cur) => acc + (cur->Js.String2.charAt(i) == "1" ? 1 : 0),
        0,
      )
    filtered := if 2 * count < numReadings {
        filtered.contents->Js.Array2.filter(reading => reading->Js.String2.charAt(i) == "1")
      } else {
        filtered.contents->Js.Array2.filter(reading => reading->Js.String2.charAt(i) == "0")
      }
    counter := i + 1
  }

  int_of_string("0b" ++ filtered.contents[0])
}

let default = (inpt: string) => {
  let readings = inpt->Js.String2.split("\n")
  let readingLength = readings[0]->Js.String2.length

  if readings->Js.Array2.some(r => r->Js.String2.length != readingLength) {
    raise(InvalidInput("One reading is not like the others"))
  }

  let o2 = o2rating(readings)
  let co2 = co2rating(readings)

  o2->Js.Int.toString ++ ", " ++ co2->Js.Int.toString ++ " => " ++ (o2 * co2)->Js.Int.toString
}
