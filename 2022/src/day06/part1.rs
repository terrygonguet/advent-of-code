use iterwindows::IterArrayWindows;

pub fn solution(puzzle: &String) -> String {
    for (i, [a, b, c, d]) in puzzle.chars().array_windows().enumerate() {
        if a != b && a != c && a != d && b != c && b != d && c != d {
            return (i + 4).to_string();
        }
    }
    0.to_string()
}
