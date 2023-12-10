let regexp_number_pos = Str.regexp "[0-9]+"
let regexp_number_neg = Str.regexp "-?[0-9]+"

let rec parse_numbers ?(allowNegative=false) line start =
	let regexp_number = if allowNegative then regexp_number_neg else regexp_number_pos in
	let x = try Str.search_forward regexp_number line start with Not_found -> -1 in
	match x with
	| -1 -> []
	| _ ->
		let n = Str.matched_string line in
		let l = String.length n in
		(int_of_string n) :: (parse_numbers ~allowNegative line (x + l))

let rec to_pairs list =
	match list with
	| a :: b :: rest -> (a, b) :: to_pairs rest
	| _ -> []