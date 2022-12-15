pub mod part1;
pub mod part2;

#[cfg(test)]
mod tests {
    use super::part1;
    use super::part2;
    use std::fs;

    fn read(path: &str) -> String {
        if let Ok(puzzle) = fs::read_to_string(path) {
            puzzle.replace("\r\n", "\n")
        } else {
            panic!("Can't read test file");
        }
    }

    #[test]
    fn part1_test() {
        let puzzle = read("src/day15/test.txt");
        assert_eq!(part1::solution(&puzzle.replace("\r\n", "\n"), 10), "26");
    }

    #[test]
    fn part2_test() {
        let puzzle = read("src/day15/test.txt");
        assert_eq!(part2::solution(&puzzle.replace("\r\n", "\n"), 20), "14 11");
    }
}
