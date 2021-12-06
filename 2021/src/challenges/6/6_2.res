let default = (inpt: string) => {
  open Js
  open! Belt

  let fishes =
    inpt
    ->String2.split(",")
    ->Array2.map(int_of_string)
    ->Array2.reduce(
      (acc, cur) => acc->Array2.mapi((n, i) => i == cur ? BigInt.add(n, BigInt.fromInt(1)) : n),
      Array.makeBy(9, _ => BigInt.zero),
    )

  for _ in 1 to 256 {
    let breeders = fishes->Array2.shift->Option.getWithDefault(BigInt.zero)
    fishes->Array2.push(breeders)->ignore
    fishes->Array2.unsafe_set(
      6,
      BigInt.add(breeders, fishes[6]->Option.getWithDefault(BigInt.zero)),
    )
  }

  fishes->Array2.reduce(BigInt.add, BigInt.zero)
}
