use std::{error::Error, fs};

mod day10;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day10/puzzle.txt")?.replace("\r\n", "\n");
    println!("Part 1: {}", day10::part1::solution(&puzzle));
    println!("Part 2: {}", day10::part2::solution(&puzzle));
    Ok(())
}
