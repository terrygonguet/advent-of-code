let rec predict sequence =
	if List.for_all ((=) 0) sequence then 0 else
	let pairs = BatList.combine (BatList.take (List.length sequence - 1) sequence) (List.tl sequence) in
	let deltas = List.map (fun (a, b) -> b - a) pairs in
	let next = predict deltas in
	let last = List.hd (List.rev sequence) in
	last + next

let solve puzzle =
	let sequences = List.map (fun line -> Utils.parse_numbers ~allowNegative:true line 0) puzzle in
	let predictions = List.map predict sequences in
	Int.to_string (List.fold_left (+) 0 predictions)