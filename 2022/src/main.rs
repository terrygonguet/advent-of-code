use std::{error::Error, fs};

mod day02;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day02/puzzle.txt")?.replace("\r\n", "\n");
    println!("{}", day02::part2::solution(&puzzle));
    Ok(())
}
