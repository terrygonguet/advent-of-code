use std::{error::Error, fs};

mod day06;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day06/puzzle.txt")?.replace("\r\n", "\n");
    println!("Part 1: {}", day06::part1::solution(&puzzle));
    println!("Part 2: {}", day06::part2::solution(&puzzle));
    Ok(())
}
