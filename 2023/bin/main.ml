let channel = open_in "./02/puzzle.txt"
let rec read_lines lines = 
  match input_line channel with
  | line -> read_lines (line :: lines)
  | exception End_of_file -> close_in channel;
  List.rev lines
let puzzle = List.rev (read_lines [])

let () = 
  print_endline "";
  print_endline (Day02part2.solve puzzle)
