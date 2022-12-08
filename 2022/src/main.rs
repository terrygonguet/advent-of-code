use std::{error::Error, fs};

mod day08;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day08/puzzle.txt")?.replace("\r\n", "\n");
    println!("Part 1: {}", day08::part1::solution(&puzzle));
    println!("Part 2: {}", day08::part2::solution(&puzzle));
    Ok(())
}
