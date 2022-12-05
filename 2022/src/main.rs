use std::{error::Error, fs};

mod day05;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day05/puzzle.txt")?.replace("\r\n", "\n");
    println!("{}", day05::part2::solution(&puzzle));
    Ok(())
}
