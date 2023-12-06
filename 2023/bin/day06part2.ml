let num_winning_ways time distance =
	let f_time = Int.to_float time in
	let f_distance = Int.to_float distance in
	let f_lower = 0.5 *. (f_time -. Float.sqrt (f_time *. f_time -. 4. *. f_distance)) in
	let f_higher = 0.5 *. ((Float.sqrt (f_time *. f_time -. 4. *. f_distance)) +. f_time) in
	let lower = 1 + Float.to_int f_lower in
	let higher = Float.to_int (Float.ceil f_higher -. 1.) in
	higher - lower + 1

let solve puzzle =
	match puzzle with
	| [times; distances] ->
		(* I do not apologize for my string crimes *)
		let time = int_of_string (List.fold_left (^) "" (List.map Int.to_string (Utils.parse_numbers times 0))) in
		let distance = int_of_string (List.fold_left (^) "" (List.map Int.to_string (Utils.parse_numbers distances 0))) in
		Int.to_string (num_winning_ways time distance)
	| _ -> "???"