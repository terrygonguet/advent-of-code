use std::collections::HashSet;

pub fn solution(puzzle: &String) -> String {
    let lines = puzzle.lines().collect::<Vec<&str>>();
    let groups = lines.chunks(3);

    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".to_string();
    let mut sum = 0;
    for group in groups {
        let set = group
            .iter()
            .map(|line| -> HashSet<char> {
                let mut set = HashSet::new();
                line.chars().for_each(|char| {
                    set.insert(char);
                });
                set
            })
            .reduce(|acc, cur| {
                let mut set = HashSet::new();
                acc.intersection(&cur).for_each(|char| {
                    set.insert(*char);
                });
                set
            })
            .unwrap();
        let char = set.iter().next().unwrap();
        sum += letters
            .chars()
            .position(|letter| letter == *char)
            .unwrap_or(0)
            + 1
    }
    sum.to_string()
}
