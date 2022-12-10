enum Op {
    Noop,
    AddX(i32),
}

impl Op {
    fn parse(str: &str) -> Option<Self> {
        let mut parts = str.split_whitespace();
        let op = parts.next();
        let v = parts.next();
        match (op, v) {
            (Some("noop"), _) => Some(Self::Noop),
            (Some("addx"), Some(v)) => match v.parse::<i32>() {
                Ok(v) => Some(Self::AddX(v)),
                Err(_) => None,
            },
            _ => None,
        }
    }

    fn cycles(&self) -> i32 {
        match self {
            Op::Noop => 1,
            Op::AddX(_) => 2,
        }
    }
}

struct Computer {
    x: i32,
    cycle: i32,
    screen: String,
}

impl Computer {
    fn new() -> Self {
        Self {
            x: 1,
            cycle: 0,
            screen: String::new(),
        }
    }

    fn step(&mut self, op: &Op) {
        for _ in 0..op.cycles() {
            let pos = (self.cycle) % 40;
            if pos == 0 {
                self.screen.push_str("\n");
            }
            if (pos - self.x).abs() <= 1 {
                self.screen.push_str("#");
            } else {
                self.screen.push_str(".");
            }
            self.cycle += 1;
        }
        match op {
            Op::Noop => (),
            Op::AddX(v) => self.x += v,
        }
    }
}

pub fn solution(puzzle: &String) -> String {
    let mut computer = Computer::new();
    for line in puzzle.lines() {
        if let Some(op) = Op::parse(line) {
            computer.step(&op);
        }
    }
    // print!("{}", computer.screen);
    computer.screen
}
