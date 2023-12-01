let channel = open_in "./01/puzzle.txt"
let rec read_lines lines = 
  match input_line channel with
  | line -> read_lines (line :: lines)
  | exception End_of_file -> close_in channel;
  List.rev lines
let puzzle = List.rev (read_lines [])

let () = print_endline (Day01part2.solve puzzle)
