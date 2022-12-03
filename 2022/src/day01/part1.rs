pub fn solution(puzzle: &String) -> String {
    let elves = puzzle.split("\n\n");
    let calories = elves.map(|elf| {
        elf.split("\n")
            .fold(0, |acc, cur| cur.parse::<i32>().unwrap_or(0) + acc)
    });

    calories
        .fold(0, |acc, cur| std::cmp::max(acc, cur))
        .to_string()
}
