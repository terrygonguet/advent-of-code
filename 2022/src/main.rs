use std::{error::Error, fs};

mod day04;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day04/puzzle.txt")?.replace("\r\n", "\n");
    println!("{}", day04::part2::solution(&puzzle));
    Ok(())
}
