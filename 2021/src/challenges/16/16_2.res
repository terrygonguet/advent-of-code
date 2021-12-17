let default = (inpt: string) => {
  open Js
  open! Belt

  let lines = inpt->String2.split("\n")
  let packets =
    lines
    ->Array2.map(line => BITS.fromHex(line))
    ->Array2.map(((p, _)) => p)
    ->Utils.unwrapOptionArray
    ->Array2.map(p => p->Utils.logAndPass->BITS.computeValue)
  Js.log(packets)
}
