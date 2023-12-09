let channel = open_in "./08/puzzle.txt"
let rec read_lines lines = 
  match input_line channel with
  | line -> read_lines (line :: lines)
  | exception End_of_file -> close_in channel;
  List.rev lines
let puzzle = read_lines []

let () = 
  print_endline "";
  print_endline (Day08part2.solve puzzle)
