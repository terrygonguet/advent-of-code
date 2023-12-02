type handful = Handful of (int * int * int)
type game = {
	handfuls: handful list;
	id: int;
}

let add_handfuls a b = 
	let Handful (ar, ag, ab) = a in
	let Handful (br, bg, bb) = b in
	Handful (ar + br, ag + bg, ab + bb)

let parse_game_id str = let id_str = Str.replace_first (Str.regexp_string "Game ") "" str in int_of_string_opt id_str

let parse_color str = 
	match String.split_on_char ' ' str with
	| [n; "red"] -> Some (Handful (int_of_string n, 0, 0))
	| [n; "green"] -> Some (Handful (0, int_of_string n, 0))
	| [n; "blue"] -> Some (Handful (0, 0, int_of_string n))
	| _ -> None

let parse_handful str = 
	let colors = Str.split (Str.regexp_string ", ") str in 
	List.fold_left add_handfuls (Handful (0, 0, 0)) (List.filter_map parse_color colors)

let parse_handfuls str = List.map parse_handful (Str.split (Str.regexp_string "; ") str)

let parse_game line = 
	match Str.split (Str.regexp_string ": ") line with
	| [part1; part2] -> (
		let id_opt = parse_game_id part1 in
		match id_opt with
		| Some id -> Some { id; handfuls = (parse_handfuls part2) }
		| _ -> None)
	| _ -> None

let handful_to_string (Handful (r, g, b)) = "[R:" ^ (Int.to_string r) ^ ", G:" ^ (Int.to_string g) ^ ", B:" ^ (Int.to_string b) ^ "]"

let game_to_string game = 
	let handfuls = List.map handful_to_string game.handfuls in
	"ID: " ^ (Int.to_string game.id) ^ "; " ^ (String.concat " / " handfuls)

let handful_max (Handful (ar, ag, ab)) (Handful (br, bg, bb)) = Handful ((Int.max ar br), (Int.max ag bg), (Int.max ab bb))

let minimum_viable_handful game = List.fold_left handful_max (Handful (0, 0, 0)) game.handfuls

let handful_power (Handful (r, g, b)) = r * g * b

let solve puzzle =
	let games = List.filter_map parse_game puzzle in
	let min_handfuls = List.map minimum_viable_handful games in
	let power = List.fold_left (fun acc handful -> acc + handful_power handful) 0 min_handfuls in
	Int.to_string power