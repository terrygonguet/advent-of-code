let default = (inpt: string) => {
  open Js
  open! Belt

  let fishes = ref(inpt->String2.split(",")->Array2.map(int_of_string))

  for _ in 1 to 80 {
    for i in fishes.contents->Array2.length - 1 downto 0 {
      let fish = fishes.contents[i]->Option.getWithDefault(-1)
      if fish == 0 {
        fishes.contents->Array2.push(8)->ignore
      }
      ignore(fishes.contents[i] = fish == 0 ? 6 : fish - 1)
    }
  }

  fishes.contents->Array2.length
}
