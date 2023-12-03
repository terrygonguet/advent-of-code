type part_number = {
	x: int;
	y: int;
	l: int;
	n: int;
}

type symbol = {
	x: int;
	y: int;
	c: string;
}

let rgx_number = Str.regexp "[0-9]+"

let rgx_symbol = Str.regexp "[^0-9.]"

let rec extract_numbers_line start y line =
	let x = try Str.search_forward rgx_number line start with Not_found -> -1 in
	match x with
	| -1 -> []
	| _ ->
		let n = Str.matched_string line in
		let l = String.length n in
		{ x; y; l; n = int_of_string n } :: (extract_numbers_line (x + l) y line)

let extract_numbers puzzle = List.concat (List.mapi (extract_numbers_line 0) puzzle)

let part_number_to_string part_number = Printf.sprintf "%d (%d; %d)[%d]" part_number.n part_number.x part_number.y part_number.l

let rec extract_symbols_line start y line =
	let x = try Str.search_forward rgx_symbol line start with Not_found -> -1 in
	match x with
	| -1 -> []
	| _ -> 
		let c = Str.matched_string line in
		{ x; y; c } :: (extract_symbols_line (x + 1) y line)

let extract_symbols puzzle = List.concat (List.mapi (extract_symbols_line 0) puzzle)

let symbol_to_string symbol = Printf.sprintf "%s (%d; %d)" symbol.c symbol.x symbol.y

let is_part_number_adjacent_to_symbol symbols { x; y; l; _ } = 
	let minx = x - 1 in
	let maxx = x + l in
	let miny = y - 1 in
	let maxy = y + 1 in
	List.exists (fun symbol -> symbol.x >= minx && symbol.x <= maxx && symbol.y >= miny && symbol.y <= maxy) symbols

let solve puzzle = 
	let parts = extract_numbers puzzle in
	let symbols = extract_symbols puzzle in
	let valid_part_numbers = List.filter (is_part_number_adjacent_to_symbol symbols) parts in
	let sum = List.fold_left (fun acc { n; _ } -> acc + n) 0 valid_part_numbers in
	(* print_endline (String.concat "\n" (List.map part_number_to_string valid_part_numbers)); *)
	(* print_endline (String.concat "\n" (List.map symbol_to_string symbols)); *)
	print_endline (Int.to_string (List.length valid_part_numbers));
	Int.to_string sum