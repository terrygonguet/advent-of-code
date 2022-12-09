use std::collections::HashSet;

enum Movement {
    Up(i32),
    Down(i32),
    Left(i32),
    Right(i32),
}

impl Movement {
    fn parse(str: &str) -> Option<Self> {
        let mut parts = str.split_whitespace();
        let dir = parts.next();
        let dist = parts.next().map(|n| n.parse().unwrap());
        match (dir, dist) {
            (Some("U"), Some(dist)) => Some(Self::Up(dist)),
            (Some("D"), Some(dist)) => Some(Self::Down(dist)),
            (Some("L"), Some(dist)) => Some(Self::Left(dist)),
            (Some("R"), Some(dist)) => Some(Self::Right(dist)),
            _ => None,
        }
    }
}

struct Rope {
    head: (i32, i32),
    tail: (i32, i32),
    visited: HashSet<(i32, i32)>,
}

impl Rope {
    fn new() -> Self {
        let mut visited = HashSet::new();
        visited.insert((0, 0));
        Self {
            head: (0, 0),
            tail: (0, 0),
            visited,
        }
    }

    fn apply(&mut self, movement: &Movement) {
        let (dist, dx, dy) = match movement {
            Movement::Up(dist) => (*dist, 0, 1),
            Movement::Down(dist) => (*dist, 0, -1),
            Movement::Left(dist) => (*dist, -1, 0),
            Movement::Right(dist) => (*dist, 1, 0),
        };
        for _ in 0..dist {
            let (x, y) = self.head;
            self.head = (x + dx, y + dy);
            self.follow();
        }
    }

    fn follow(&mut self) {
        let (hx, hy) = self.head;
        let (tx, ty) = self.tail;
        let deltax = hx - tx;
        let deltay = hy - ty;
        if deltax.abs() <= 1 && deltay.abs() <= 1 {
            return;
        }
        self.tail = (tx + deltax.signum(), ty + deltay.signum());
        self.visited.insert(self.tail);
    }
}

pub fn solution(puzzle: &String) -> String {
    let mut rope = Rope::new();
    for line in puzzle.lines() {
        if let Some(movement) = Movement::parse(line) {
            rope.apply(&movement);
        } else {
            println!("Could not parse movement '{line}'!");
        }
    }
    rope.visited.len().to_string()
}
