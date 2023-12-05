type range = {
	source_start: int;
	destination_start: int;
	length: int;
}

type almanac_map = {
	source: string;
	destination: string;
	ranges: range list;
}

let parse_range line =
	match Utils.parse_numbers line 0 with
	| [destination_start; source_start; length] -> Some { source_start; destination_start; length }
	| _ -> None

let regexp_header = Str.regexp {|\(.+\)-to-\(.+\) map:|}

let parse_almanac_map str =
	let lines = String.split_on_char '\n' str in
	match lines with
	| [] -> None
	| header :: ranges ->
		match Str.string_match regexp_header header 0 with
		| false -> None
		| true ->
			let source = Str.matched_group 1 header in
			let destination = Str.matched_group 2 header in
			let ranges = List.filter_map parse_range ranges in
			Some { source; destination; ranges }

let map_value { ranges; _ } value =
	let range = List.find_opt (fun { source_start; length; _ } -> value >= source_start && value < source_start + length) ranges in
	match range with
	| None -> value
	| Some { source_start; destination_start; _ } -> destination_start + (value - source_start)

let map_seed_to_location maps seed =
	let seed_to_soil = List.find (fun { source; destination; _ } -> source = "seed" && destination = "soil") maps in
	let soil_to_fertilizer = List.find (fun { source; destination; _ } -> source = "soil" && destination = "fertilizer") maps in
	let fertilizer_to_water = List.find (fun { source; destination; _ } -> source = "fertilizer" && destination = "water") maps in
	let water_to_light = List.find (fun { source; destination; _ } -> source = "water" && destination = "light") maps in
	let light_to_temperature = List.find (fun { source; destination; _ } -> source = "light" && destination = "temperature") maps in
	let temperature_to_humidity = List.find (fun { source; destination; _ } -> source = "temperature" && destination = "humidity") maps in
	let humidity_to_location = List.find (fun { source; destination; _ } -> source = "humidity" && destination = "location") maps in
	let soil = map_value seed_to_soil seed in
	let fertilizer = map_value soil_to_fertilizer soil in
	let water = map_value fertilizer_to_water fertilizer in
	let light = map_value water_to_light water in
	let temperature = map_value light_to_temperature light in
	let humidity = map_value temperature_to_humidity temperature in
	let location = map_value humidity_to_location humidity in
	location

let solve lines =
	let puzzle = String.concat "\n" lines in
	match Str.split (Str.regexp_string "\n\n") puzzle with
	| [] -> "???"
	| seeds :: maps ->
		let seeds = Utils.parse_numbers seeds 0 in
		let maps = List.filter_map parse_almanac_map maps in
		let seed_to_location = map_seed_to_location maps in
		let locations = List.map seed_to_location seeds in
		let minimum = List.fold_left (min) Int.max_int locations in
		Int.to_string minimum