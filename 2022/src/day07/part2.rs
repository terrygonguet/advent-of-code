use std::collections::HashMap;

const TOTAL_SIZE: i32 = 70000000;
const UPDATE_SIZE: i32 = 30000000;

pub fn solution(puzzle: &String) -> String {
    let mut paths = HashMap::new();
    let mut cur_path = vec![];

    for line in puzzle.lines() {
        if line.starts_with("$ cd") {
            let mut parts = line.split_whitespace();
            parts.next(); // $
            parts.next(); // cd
            match parts.next() {
                Some("..") => {
                    cur_path.pop();
                }
                Some("/") => cur_path = vec![],
                Some(name) => cur_path.push(name),
                None => (),
            }
        } else if line == "$ ls" {
            // ignore
        } else if line.starts_with("dir") {
            // ignore
        } else {
            let mut parts = line.split_whitespace();
            let size = parts.next();
            let name = parts.next();
            if let (Some(size), Some(name)) = (size, name) {
                let mut full_path = cur_path.clone();
                full_path.push(name);
                paths.insert(full_path, size.parse::<i32>().unwrap());
            }
        }
    }

    let mut total = 0;
    let mut dir_sizes = HashMap::new();
    for (mut path, size) in paths {
        path.pop();
        total += size;
        for i in 1..=path.len() {
            dir_sizes
                .entry(path[..i].join("/"))
                .and_modify(|cur| *cur += size)
                .or_insert(size);
        }
    }

    let diff = UPDATE_SIZE - (TOTAL_SIZE - total);
    let mut candidates = HashMap::new();
    for (dir, size) in dir_sizes {
        if size >= diff {
            candidates.insert(dir, size);
        }
    }

    let mut sorted = candidates.into_values().collect::<Vec<i32>>();
    sorted.sort();
    sorted[0].to_string()
}
