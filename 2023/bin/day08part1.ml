module NodeMap = Map.Make (String)

type node = {
	name: string;
	left: string;
	right: string;
}

let regexp_node = Str.regexp {|^\(...\) = (\(...\), \(...\))$|}

let parse_node line =
	match Str.string_match regexp_node line 0 with
	| false -> None
	| true ->
		try
			let name = Str.matched_group 1 line in
			let left = Str.matched_group 2 line in
			let right = Str.matched_group 3 line in
			Some ({ name; left; right })
		with Not_found -> None

let node_to_string ({ name; left; right }) = Printf.sprintf "%s = (%s, %s)" name left right

let build_node_map nodes = List.fold_left (fun acc node -> NodeMap.add node.name node acc) NodeMap.empty nodes

let rec follow_path map current path n =
	if current.name = "ZZZ" then n else
	let step = List.nth path (Int.rem n (List.length path)) in
	let next = if step = 'R' then current.right else current.left in
	match NodeMap.find_opt next map with
	| None -> -1
	| Some next -> follow_path map next path (n + 1)

let solve puzzle =
	match puzzle with
	| path :: _ :: nodes ->
		let path = BatString.to_list path in
		let nodes = List.filter_map parse_node nodes in
		let map = build_node_map nodes in
		let start = NodeMap.find "AAA" map in
		let n = follow_path map start path 0 in
		Int.to_string n
	| _ -> "???"