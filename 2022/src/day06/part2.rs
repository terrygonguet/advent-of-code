use std::collections::HashSet;

use iterwindows::IterArrayWindows;

pub fn solution(puzzle: &String) -> String {
    for (i, chars) in puzzle.chars().array_windows::<14>().enumerate() {
        let set = HashSet::from(chars);
        if set.len() == 14 {
            return (i + 14).to_string();
        }
    }
    0.to_string()
}
