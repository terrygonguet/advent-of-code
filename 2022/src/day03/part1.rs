use std::collections::HashSet;

pub fn solution(puzzle: &String) -> String {
    let mismatched = puzzle.lines().map(|line| -> char {
        let half = line.len() / 2;
        let mut left = HashSet::new();
        let mut right = HashSet::new();
        line.chars().enumerate().for_each(|(i, char)| {
            if i < half {
                left.insert(char);
            } else {
                right.insert(char);
            }
        });
        *left.intersection(&right).next().unwrap()
    });
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".to_string();
    mismatched
        .map(|char| letters.chars().position(|letter| letter == char))
        .fold(0, |acc, cur| acc + cur.unwrap_or(0) + 1)
        .to_string()
}
