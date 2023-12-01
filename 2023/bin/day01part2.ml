let rec first line = 
  if BatString.starts_with line "0" then 0 else
  if BatString.starts_with line "1" then 1 else
  if BatString.starts_with line "2" then 2 else
  if BatString.starts_with line "3" then 3 else
  if BatString.starts_with line "4" then 4 else
  if BatString.starts_with line "5" then 5 else
  if BatString.starts_with line "6" then 6 else
  if BatString.starts_with line "7" then 7 else
  if BatString.starts_with line "8" then 8 else
  if BatString.starts_with line "9" then 9 else
  if BatString.starts_with line "one" then 1 else
  if BatString.starts_with line "two" then 2 else
  if BatString.starts_with line "three" then 3 else
  if BatString.starts_with line "four" then 4 else
  if BatString.starts_with line "five" then 5 else
  if BatString.starts_with line "six" then 6 else
  if BatString.starts_with line "seven" then 7 else
  if BatString.starts_with line "eight" then 8 else
  if BatString.starts_with line "nine" then 9 else
  first (BatString.sub line 1 (String.length line - 1))

let rec last line = 
  if BatString.ends_with line "0" then 0 else
  if BatString.ends_with line "1" then 1 else
  if BatString.ends_with line "2" then 2 else
  if BatString.ends_with line "3" then 3 else
  if BatString.ends_with line "4" then 4 else
  if BatString.ends_with line "5" then 5 else
  if BatString.ends_with line "6" then 6 else
  if BatString.ends_with line "7" then 7 else
  if BatString.ends_with line "8" then 8 else
  if BatString.ends_with line "9" then 9 else
  if BatString.ends_with line "one" then 1 else
  if BatString.ends_with line "two" then 2 else
  if BatString.ends_with line "three" then 3 else
  if BatString.ends_with line "four" then 4 else
  if BatString.ends_with line "five" then 5 else
  if BatString.ends_with line "six" then 6 else
  if BatString.ends_with line "seven" then 7 else
  if BatString.ends_with line "eight" then 8 else
  if BatString.ends_with line "nine" then 9 else
  last (BatString.sub line 0 (String.length line - 1))

let strip_letters line = 
  let nums = String.fold_left (
    fun acc cur -> 
      match cur with
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

let skadoodle line = 
  let first = first line in
  let last = last line in
  10 * first + last

let solve puzzle =
  let calibrations = List.map skadoodle puzzle in
  let total = List.fold_left (Int.add) 0 calibrations in
  Int.to_string total