module IntSet = Set.Make(Int)

type scratchcard = {
	id: int;
	winners: IntSet.t;
	numbers: IntSet.t;
}

let regexp_card = Str.regexp {|^Card +\([0-9]+\): \([^\|]+\) | \(.+\)$|}

let regexp_number = Str.regexp "[0-9]+"

let rec parse_numbers str start = 
	let x = try Str.search_forward regexp_number str start with Not_found -> -1 in
	match x with
	| -1 -> IntSet.empty
	| _ ->
		let n = Str.matched_string str in
		let l = String.length n in
		IntSet.add (int_of_string n) (parse_numbers str (x + l))

let parse_scratchcard line = 
	match Str.string_match regexp_card line 0 with
	| false -> None
	| true  -> 
		let id = try Str.matched_group 1 line with Not_found -> "-1" in
		let winners = try Str.matched_group 2 line with Not_found -> "" in
		let numbers = try Str.matched_group 3 line with Not_found -> "" in
		Some {
			id = int_of_string id;
			winners = parse_numbers winners 0;
			numbers = parse_numbers numbers 0
		}

let scratchcard_to_string card = 
	let winners = IntSet.fold (fun cur acc -> acc ^ " " ^ (Int.to_string cur)) card.winners "" in
	let numbers = IntSet.fold (fun cur acc -> acc ^ " " ^ (Int.to_string cur)) card.numbers "" in
	Printf.sprintf "Card %d:%s |%s" card.id winners numbers

let score card =
	let intersection = IntSet.inter card.winners card.numbers in
	let n = Int.to_float (IntSet.cardinal intersection) in
	if n = 0. then 0. else 2. ** (n -. Float.one)

let solve puzzle =
	let cards = List.filter_map parse_scratchcard puzzle in
	(* let strings = List.map scratchcard_to_string cards in 
	print_endline (String.concat "\n" strings); *)
	let scores = List.map score cards in
	let total = List.fold_left (+.) 0. scores in
	Float.to_string total