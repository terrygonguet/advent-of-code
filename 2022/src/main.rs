use std::{error::Error, fs};

mod day09;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day09/puzzle.txt")?.replace("\r\n", "\n");
    println!("Part 1: {}", day09::part1::solution(&puzzle));
    println!("Part 2: {}", day09::part2::solution(&puzzle));
    Ok(())
}
