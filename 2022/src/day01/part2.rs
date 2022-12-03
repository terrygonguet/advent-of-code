pub fn solution(puzzle: &String) -> String {
    let elves = puzzle.split("\n\n");
    let mut calories: Vec<i32> = elves
        .map(|elf| {
            elf.split("\n")
                .fold(0, |acc, cur| cur.parse::<i32>().unwrap_or(0) + acc)
        })
        .collect();

    calories.sort();
    calories.reverse();
    calories[..3]
        .iter()
        .fold(0, |acc, cur| acc + cur)
        .to_string()
}
