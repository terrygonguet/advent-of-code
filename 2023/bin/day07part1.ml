type card = A |  K |  Q |  J |  T |  C9 |  C8 |  C7 |  C6 |  C5 |  C4 |  C3 |  C2

type hand_type = FiveOaK | FourOaK | FullHouse | ThreeOaK | TwoPair | OnePair | Card

type hand = Hand of (card * card * card * card * card)

let parse_card str =
	match str with
	| 'A' -> Some A
	| 'K' -> Some K
	| 'Q' -> Some Q
	| 'J' -> Some J
	| 'T' -> Some T
	| '9' -> Some C9
	| '8' -> Some C8
	| '7' -> Some C7
	| '6' -> Some C6
	| '5' -> Some C5
	| '4' -> Some C4
	| '3' -> Some C3
	| '2' -> Some C2
	| _ -> None

let card_to_string card =
	match card with
	| A -> "A"
	| K -> "K"
	| Q -> "Q"
	| J -> "J"
	| T -> "T"
	| C9 -> "9"
	| C8 -> "8"
	| C7 -> "7"
	| C6 -> "6"
	| C5 -> "5"
	| C4 -> "4"
	| C3 -> "3"
	| C2 -> "2"

let card_to_int card =
	match card with
	| A -> 14
	| K -> 13
	| Q -> 12
	| J -> 11
	| T -> 10
	| C9 -> 9
	| C8 -> 8
	| C7 -> 7
	| C6 -> 6
	| C5 -> 5
	| C4 -> 4
	| C3 -> 3
	| C2 -> 2

let compare_cards a b = (card_to_int a) - (card_to_int b)

let parse_hand str =
	match BatString.to_list str with
	| [a; b; c; d; e] -> (
		match (parse_card a, parse_card b, parse_card c, parse_card d, parse_card e) with
		| (Some a, Some b, Some c, Some d, Some e) -> Some (Hand (a, b, c, d, e))
		| _ -> None
	)
	| _ -> None

let hand_to_string (Hand (a, b, c, d, e)) = (card_to_string a) ^ (card_to_string b) ^ (card_to_string c) ^ (card_to_string d) ^ (card_to_string e)

let hand_type (Hand (a, b, c, d, e)) =
	match List.sort compare_cards [a; b; c; d; e] with
	| [a; b; c; d; e] ->
		if a=b && a=c && a=d && a=e then FiveOaK else (* AAAAA *)
		if a=b && a=c && a=d then FourOaK else (* AAAA_ *)
		if b=c && b=d && b=e then FourOaK else (* _AAAA *)
		if a=b && a=c && d=e then FullHouse else (* AAABB *)
		if a=b && c=d && c=e then FullHouse else (* AABBB *)
		if a=b && a=c then ThreeOaK else (* AAA__ *)
		if b=c && b=d then ThreeOaK else (* _AAA_ *)
		if c=d && c=e then ThreeOaK else (* __AAA *)
		if a=b && c=d then TwoPair else (* AABB_ *)
		if a=b && d=e then TwoPair else (* AA_BB *)
		if b=c && d=e then TwoPair else (* _AABB *)
		if a=b then OnePair else (* AA___ *)
		if b=c then OnePair else (* _AA__ *)
		if c=d then OnePair else (* __AA_ *)
		if d=e then OnePair else (* ___AA *)
		Card
	| _ -> raise (Invalid_argument "hand")

let type_to_string hand_type =
	match hand_type with
	| FiveOaK -> "Five of a kind"
	| FourOaK -> "Four of a kind"
	| ThreeOaK -> "Three of a kind"
	| FullHouse -> "Full house"
	| TwoPair -> "Two pairs"
	| OnePair -> "One pair"
	| Card -> "High card"

let type_to_int hand_type =
	match hand_type with
	| FiveOaK -> 7
	| FourOaK -> 6
	| FullHouse -> 5
	| ThreeOaK -> 4
	| TwoPair -> 3
	| OnePair -> 2
	| Card -> 1

let compare_type a b = (type_to_int a) - (type_to_int b)

let compare_hands a b =
	let type_a = hand_type a in
	let type_b = hand_type b in
	match compare_type type_a type_b with
	| 0 -> 
		let Hand (aa, ab, ac, ad, ae) = a in 
		let Hand (ba, bb, bc, bd, be) = b in 
		let cmp_a = compare_cards aa ba in
		if cmp_a <> 0 then cmp_a else
			let cmp_b = compare_cards ab bb in
			if cmp_b <> 0 then cmp_b else
				let cpm_c = compare_cards ac bc in
				if cpm_c <> 0 then cpm_c else
					let cmp_d = compare_cards ad bd in
					if cmp_d <> 0 then cmp_d else
						compare_cards ae be
	| n -> n

let regexp_game = Str.regexp {|^\(.....\) \([0-9]+\)$|}

let parse_line line =
	match Str.string_match regexp_game line 0 with
	| false -> None
	| true ->
		let hand = try Str.matched_group 1 line with Not_found -> "" in
		let bid = try Str.matched_group 2 line with Not_found -> "" in
		match (parse_hand hand, int_of_string_opt bid) with
		| (Some hand, Some bid) -> Some (hand, bid)
		| _ -> None

let solve puzzle =
	let games = List.filter_map parse_line puzzle in
	let sorted = List.sort (fun (a, _) (b, _) -> compare_hands a b) games in
	(* List.iter (fun (hand, bid) -> print_endline ((type_to_string (hand_type hand)) ^ " " ^ (hand_to_string hand) ^ " " ^ (Int.to_string bid))) sorted; *)
	let score = BatList.fold_lefti (fun acc i (_, bid) -> acc + (i + 1) * bid) 0 sorted in
	Int.to_string score