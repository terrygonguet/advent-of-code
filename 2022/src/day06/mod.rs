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
    fn part1_test1() {
        let puzzle = read("src/day06/test1.txt");
        assert_eq!(part1::solution(&puzzle.replace("\r\n", "\n")), "7");
    }

    #[test]
    fn part1_test2() {
        let puzzle = read("src/day06/test2.txt");
        assert_eq!(part1::solution(&puzzle.replace("\r\n", "\n")), "5");
    }

    #[test]
    fn part1_test3() {
        let puzzle = read("src/day06/test3.txt");
        assert_eq!(part1::solution(&puzzle.replace("\r\n", "\n")), "6");
    }

    #[test]
    fn part1_test4() {
        let puzzle = read("src/day06/test4.txt");
        assert_eq!(part1::solution(&puzzle.replace("\r\n", "\n")), "10");
    }

    #[test]
    fn part1_test5() {
        let puzzle = read("src/day06/test5.txt");
        assert_eq!(part1::solution(&puzzle.replace("\r\n", "\n")), "11");
    }

    #[test]
    fn part2_test1() {
        let puzzle = read("src/day06/test1.txt");
        assert_eq!(part2::solution(&puzzle.replace("\r\n", "\n")), "19");
    }

    #[test]
    fn part2_test2() {
        let puzzle = read("src/day06/test2.txt");
        assert_eq!(part2::solution(&puzzle.replace("\r\n", "\n")), "23");
    }

    #[test]
    fn part2_test3() {
        let puzzle = read("src/day06/test3.txt");
        assert_eq!(part2::solution(&puzzle.replace("\r\n", "\n")), "23");
    }

    #[test]
    fn part2_test4() {
        let puzzle = read("src/day06/test4.txt");
        assert_eq!(part2::solution(&puzzle.replace("\r\n", "\n")), "29");
    }

    #[test]
    fn part2_test5() {
        let puzzle = read("src/day06/test5.txt");
        assert_eq!(part2::solution(&puzzle.replace("\r\n", "\n")), "26");
    }
}
