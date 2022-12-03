use std::{error::Error, fs};

mod day02;

fn main() -> Result<(), Box<dyn Error>> {
    let puzzle = fs::read_to_string("src/day02/test.txt")?.replace("\r\n", "\n");
    println!("{}", day02::part1::solution(&puzzle));
    Ok(())
}
