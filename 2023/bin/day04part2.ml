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

let card_score card =
	let intersection = IntSet.inter card.winners card.numbers in
	IntSet.cardinal intersection

let solve puzzle =
	let cards = List.filter_map parse_scratchcard puzzle in
	let copies = Hashtbl.create (List.length cards) in
	let sum = List.fold_left (fun sum card -> begin
		(* 1. compute card score *)
		let score = card_score card in
		(* 2. win copies *)
		let num_copies = 1 + Option.value (Hashtbl.find_opt copies card.id) ~default:0 in
		List.iter (fun i -> begin
			let idx = card.id + i in
			let cur = Option.value (Hashtbl.find_opt copies idx) ~default:0 in
			Hashtbl.replace copies idx (cur + num_copies);
		end) (List.init score succ);
		(* 3. return number of copies of current card *)
		sum + num_copies
	end) 0 cards in
	Int.to_string sum