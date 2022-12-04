use std::{error::Error, fs};

mod day03;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day03/puzzle.txt")?.replace("\r\n", "\n");
    println!("{}", day03::part2::solution(&puzzle));
    Ok(())
}
