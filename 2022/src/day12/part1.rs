use std::collections::HashMap;

use pathfinding::prelude::dijkstra;

#[derive(Clone, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
struct Pos(i32, i32);

pub fn solution(puzzle: &String) -> String {
    let mut start = Pos(0, 0);
    let mut goal = Pos(0, 0);
    let mut grid = HashMap::new();

    for (y, line) in puzzle.lines().enumerate() {
        for (x, char) in line.bytes().enumerate() {
            let x = x as i32;
            let y = y as i32;
            if char == b'S' {
                start = Pos(x, y);
                grid.insert(start.clone(), b'a');
            } else if char == b'E' {
                goal = Pos(x, y);
                grid.insert(goal.clone(), b'z');
            } else {
                grid.insert(Pos(x, y), char);
            }
        }
    }

    let result = dijkstra(
        &start,
        |p| {
            let cur = grid[p];
            let &Pos(x, y) = p;
            let mut successors = vec![];
            let up = Pos(x, y + 1);
            if let Some(height) = grid.get(&up) {
                if cur >= *height || cur == height - 1 {
                    successors.push((up, 1));
                }
            }
            let down = Pos(x, y - 1);
            if let Some(height) = grid.get(&down) {
                if cur >= *height || cur == height - 1 {
                    successors.push((down, 1));
                }
            }
            let left = Pos(x - 1, y);
            if let Some(height) = grid.get(&left) {
                if cur >= *height || cur == height - 1 {
                    successors.push((left, 1));
                }
            }
            let right = Pos(x + 1, y);
            if let Some(height) = grid.get(&right) {
                if cur >= *height || cur == height - 1 {
                    successors.push((right, 1));
                }
            }
            successors
        },
        |p| *p == goal,
    );

    if let Some((_path, length)) = result {
        length.to_string()
    } else {
        "No path".to_string()
    }
}
