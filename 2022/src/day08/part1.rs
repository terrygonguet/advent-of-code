pub fn solution(puzzle: &String) -> String {
    let mut grid = vec![];
    for line in puzzle.lines() {
        let row = line
            .chars()
            .map(|char| char.to_string().parse::<i32>().unwrap())
            .collect::<Vec<i32>>();
        grid.push(row);
    }

    let mut num_visible = 0;
    for (y, row) in grid.iter().enumerate() {
        for (x, _) in row.iter().enumerate() {
            if is_visible(&grid, x, y) {
                num_visible += 1;
            }
        }
    }

    num_visible.to_string()
}

fn is_visible(grid: &Vec<Vec<i32>>, x: usize, y: usize) -> bool {
    if x == 0 || y == 0 || y == grid.len() - 1 || x == grid[y].len() - 1 {
        return true;
    }

    let height = grid[y][x];
    let mut visible_from_top = true;
    for cur in 0..y {
        if grid[cur][x] >= height {
            visible_from_top = false;
            break;
        }
    }
    if visible_from_top {
        return true;
    }

    let mut visible_from_bottom = true;
    for cur in (y + 1)..grid.len() {
        if grid[cur][x] >= height {
            visible_from_bottom = false;
            break;
        }
    }
    if visible_from_bottom {
        return true;
    }

    let mut visible_from_left = true;
    for cur in 0..x {
        if grid[y][cur] >= height {
            visible_from_left = false;
            break;
        }
    }
    if visible_from_left {
        return true;
    }

    let mut visible_from_right = true;
    for cur in (x + 1)..grid[y].len() {
        if grid[y][cur] >= height {
            visible_from_right = false;
            break;
        }
    }
    if visible_from_right {
        return true;
    }

    false
}
