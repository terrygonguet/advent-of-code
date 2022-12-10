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
    next_sample: Option<i32>,
}

impl Computer {
    fn new() -> Self {
        Self {
            x: 1,
            cycle: 0,
            next_sample: Some(20),
        }
    }

    fn step(&mut self, op: &Op, acc: &mut i32) {
        for _ in 0..op.cycles() {
            self.cycle += 1;
            if let Some(next_sample) = self.next_sample {
                if self.cycle >= next_sample {
                    *acc += self.signal_strength();
                    self.next_sample = if next_sample < 200 {
                        Some(next_sample + 40)
                    } else {
                        None
                    };
                }
            }
        }
        match op {
            Op::Noop => (),
            Op::AddX(v) => self.x += v,
        }
        if let Some(next_sample) = self.next_sample {
            if self.cycle >= next_sample {
                *acc += self.signal_strength();
                self.next_sample = if next_sample < 200 {
                    Some(next_sample + 40)
                } else {
                    None
                };
            }
        }
    }

    fn signal_strength(&self) -> i32 {
        self.cycle * self.x
    }
}

pub fn solution(puzzle: &String) -> String {
    let mut computer = Computer::new();
    let mut sum = 0;
    for line in puzzle.lines() {
        if let Some(op) = Op::parse(line) {
            computer.step(&op, &mut sum);
        }
    }
    sum.to_string()
}
