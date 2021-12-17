type rec packet =
  | Literal({version: int, value: BigInt.t})
  | Sum({version: int, subpackets: array<packet>})
  | Product({version: int, subpackets: array<packet>})
  | Minimum({version: int, subpackets: array<packet>})
  | Maximum({version: int, subpackets: array<packet>})
  | GreaterThan({version: int, subpackets: array<packet>})
  | LessThan({version: int, subpackets: array<packet>})
  | EqualTo({version: int, subpackets: array<packet>})

let parseLiteral = (bits: string, version: int) => {
  let i = ref(0)
  let valueBin = ref("")
  let done = ref(false)
  while !done.contents {
    done := bits->Js.String2.charAt(6 + i.contents * 5) == "0"
    valueBin :=
      valueBin.contents ++ bits->Js.String2.substrAtMost(~from=i.contents * 5 + 7, ~length=4)
    incr(i)
  }
  let value = BigInt.fromString("0b" ++ valueBin.contents)
  let remainder = bits->Js.String2.substringToEnd(~from=6 + i.contents * 5)
  (Some(Literal({version: version, value: value})), remainder)
}

let rec parseOperatorByLength = (bits: string) => {
  let subpacketsLength = int_of_string("0b" ++ bits->Js.String2.substrAtMost(~from=7, ~length=15))

  let data = ref(bits->Js.String2.substrAtMost(~from=22, ~length=subpacketsLength))
  let subpackets = []
  let done = ref(false)
  while !done.contents {
    let (packet, remainder) = fromBits(data.contents)
    switch packet {
    | Some(packet) => subpackets->Js.Array2.push(packet)->ignore
    | None => done := true
    }
    data := remainder
  }

  let remainder = bits->Js.String2.substringToEnd(~from=22 + subpacketsLength)
  (subpackets, remainder)
}

and parseOperatorByCount = (bits: string) => {
  let numPackets = int_of_string("0b" ++ bits->Js.String2.substrAtMost(~from=7, ~length=11))

  let data = ref(bits->Js.String2.substringToEnd(~from=18))
  let subpackets = []
  for _ in 1 to numPackets {
    let (packet, remainder) = fromBits(data.contents)
    switch packet {
    | Some(packet) => subpackets->Js.Array2.push(packet)->ignore
    | None => ()
    }
    data := remainder
  }

  (subpackets, data.contents)
}

and parseOperator = (bits: string) =>
  switch bits->Js.String2.charAt(6) {
  | "0" => parseOperatorByLength(bits)
  | "1" => parseOperatorByCount(bits)
  | _ => Js.Exn.raiseError("wtf")
  }

and fromBits = (bits: string) => {
  open Js
  open! Belt

  //   Js.log2("fromBits", bits)
  if bits->String2.length < 11 {
    (None, "")
  } else {
    let version = int_of_string("0b" ++ bits->String2.substrAtMost(~from=0, ~length=3))
    let typeId = int_of_string("0b" ++ bits->String2.substrAtMost(~from=3, ~length=3))
    switch typeId {
    | 4 => parseLiteral(bits, version)
    | _ => {
        let (subpackets, remainder) = parseOperator(bits)
        switch typeId {
        | 0 => (Some(Sum({subpackets: subpackets, version: version})), remainder)
        | 1 => (Some(Product({subpackets: subpackets, version: version})), remainder)
        | 2 => (Some(Minimum({subpackets: subpackets, version: version})), remainder)
        | 3 => (Some(Maximum({subpackets: subpackets, version: version})), remainder)
        | _ =>
          if subpackets->Array2.length == 2 {
            switch typeId {
            | 5 => (Some(GreaterThan({subpackets: subpackets, version: version})), remainder)
            | 6 => (Some(LessThan({subpackets: subpackets, version: version})), remainder)
            | 7 => (Some(EqualTo({subpackets: subpackets, version: version})), remainder)
            | _ => Exn.raiseError("wtf")
            }
          } else {
            Exn.raiseError("wtf")
          }
        }
      }
    }
  }
}

let fromHex = (hex: string) =>
  hex
  ->Utils.logAndPass
  ->Js.String2.split("")
  ->Js.Array2.map(char => int_of_string("0x" ++ char))
  ->Js.Array2.map(n => n->Js.Int.toStringWithRadix(~radix=2)->Utils.padStart(4, "0"))
  ->Js.Array2.joinWith("")
  ->fromBits

let rec sumVersions = (packet: packet) =>
  switch packet {
  | Literal({version}) => version
  | Sum({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  | Product({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  | Minimum({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  | Maximum({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  | GreaterThan({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  | LessThan({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  | EqualTo({version, subpackets}) =>
    version + subpackets->Js.Array2.reduce((sum, packet) => sum + sumVersions(packet), 0)
  }

let rec computeValue = (packet: packet) =>
  switch packet {
  | Literal({value}) => value
  | Sum({subpackets}) =>
    subpackets->Js.Array2.reduce(
      (acc, packet) => BigInt.add(acc, packet->computeValue),
      BigInt.zero,
    )
  | Product({subpackets}) =>
    subpackets->Js.Array2.reduce(
      (acc, packet) => BigInt.mult(acc, packet->computeValue),
      BigInt.one,
    )
  | Minimum({subpackets}) =>
    subpackets->Js.Array2.reduce(
      (acc, packet) => BigInt.min(acc, packet->computeValue),
      BigInt.fromString("999999999999999999999999999999999"),
    )
  | Maximum({subpackets}) =>
    subpackets->Js.Array2.reduce(
      (acc, packet) => BigInt.max(acc, packet->computeValue),
      BigInt.zero,
    )
  | GreaterThan({subpackets}) => {
      let v1 = subpackets->Belt.Array.getExn(0)->computeValue
      let v2 = subpackets->Belt.Array.getExn(1)->computeValue
      BigInt.cmp(v1, v2) > 0 ? BigInt.one : BigInt.zero
    }
  | LessThan({subpackets}) => {
      let v1 = subpackets->Belt.Array.getExn(0)->computeValue
      let v2 = subpackets->Belt.Array.getExn(1)->computeValue
      BigInt.cmp(v1, v2) < 0 ? BigInt.one : BigInt.zero
    }
  | EqualTo({subpackets}) => {
      let v1 = subpackets->Belt.Array.getExn(0)->computeValue
      let v2 = subpackets->Belt.Array.getExn(1)->computeValue
      BigInt.eq(v1, v2) ? BigInt.one : BigInt.zero
    }
  }
