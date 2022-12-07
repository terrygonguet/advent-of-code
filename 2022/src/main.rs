use std::{error::Error, fs};

mod day07;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day07/puzzle.txt")?.replace("\r\n", "\n");
    println!("Part 1: {}", day07::part1::solution(&puzzle));
    println!("Part 2: {}", day07::part2::solution(&puzzle));
    Ok(())
}
