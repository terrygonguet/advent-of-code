pub fn solution(puzzle: &String) -> String {
    let mut grid = vec![];
    for line in puzzle.lines() {
        let row = line
            .chars()
            .map(|char| char.to_string().parse::<i32>().unwrap())
            .collect::<Vec<i32>>();
        grid.push(row);
    }

    let mut max_score = 0;
    for (y, row) in grid.iter().enumerate() {
        for (x, _) in row.iter().enumerate() {
            max_score = max_score.max(score(&grid, x, y));
        }
    }

    max_score.to_string()
}

fn score(grid: &Vec<Vec<i32>>, x: usize, y: usize) -> usize {
    if x == 0 || y == 0 || y == grid.len() - 1 || x == grid[y].len() - 1 {
        return 0;
    }

    let height = grid[y][x];
    let mut total = 1;

    // bottom
    let mut range = 1;
    loop {
        if y + range >= grid.len() {
            range -= 1;
            break;
        } else if grid[y + range][x] >= height {
            break;
        } else {
            range += 1;
        }
    }
    total *= range;

    // top
    range = 1;
    loop {
        if y < range {
            range -= 1;
            break;
        } else if grid[y - range][x] >= height {
            break;
        } else {
            range += 1;
        }
    }
    total *= range;

    // right
    range = 1;
    loop {
        if x + range >= grid[y].len() {
            range -= 1;
            break;
        } else if grid[y][x + range] >= height {
            break;
        } else {
            range += 1;
        }
    }
    total *= range;

    // left
    range = 1;
    loop {
        if x < range {
            range -= 1;
            break;
        } else if grid[y][x - range] >= height {
            break;
        } else {
            range += 1;
        }
    }
    total *= range;

    total
}
