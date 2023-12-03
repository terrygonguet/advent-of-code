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

let rgx_symbol = Str.regexp "\\*"

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

let is_part_number_adjacent_to_symbol symbol { x; y; l; _ } = 
	let minx = x - 1 in
	let maxx = x + l in
	let miny = y - 1 in
	let maxy = y + 1 in
	symbol.x >= minx && symbol.x <= maxx && symbol.y >= miny && symbol.y <= maxy

let gear_ratio part_numbers symbol =
	let adjacent = List.filter (is_part_number_adjacent_to_symbol symbol) part_numbers in
	match adjacent with
	| [{ n = a; _ }; { n = b; _ }] -> a * b
	| _ -> 0

let solve puzzle = 
	let parts = extract_numbers puzzle in
	let symbols = extract_symbols puzzle in
	let ratio = gear_ratio parts in
	let sum = List.fold_left (fun acc symbol -> acc + (ratio symbol)) 0 symbols in
	Int.to_string sum