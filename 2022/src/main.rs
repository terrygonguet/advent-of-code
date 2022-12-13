// #[macro_use]
// extern crate lazy_static;
// extern crate regex;

use std::{error::Error, fs};

mod day13;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day13/puzzle.txt")?.replace("\r\n", "\n");
    println!("Part 1: {}", day13::part1::solution(&puzzle));
    println!("Part 2: {}", day13::part2::solution(&puzzle));
    Ok(())
}
