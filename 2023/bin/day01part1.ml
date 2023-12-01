let strip_letters line = 
  let nums = String.fold_left (fun acc cur -> match cur with
    | '0' -> 0 :: acc
    | '1' -> 1 :: acc
    | '2' -> 2 :: acc
    | '3' -> 3 :: acc
    | '4' -> 4 :: acc
    | '5' -> 5 :: acc
    | '6' -> 6 :: acc
    | '7' -> 7 :: acc
    | '8' -> 8 :: acc
    | '9' -> 9 :: acc
    | _ -> acc
    ) [] line in List.rev nums

let skadoodle nums = 
  let first = List.hd nums in
  let last = List.hd (List.rev nums) in
  10 * first + last

let solve puzzle =
  let nums = List.map strip_letters puzzle in
  let calibrations = List.map skadoodle nums in
  let total = List.fold_left (Int.add) 0 calibrations in
  Int.to_string total