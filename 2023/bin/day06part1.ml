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
		let times = Utils.parse_numbers times 0 in
		let distances = Utils.parse_numbers distances 0 in
		let ways = List.map2 num_winning_ways times distances in
		Int.to_string (List.fold_left Int.mul 1 ways)
	| _ -> "???"