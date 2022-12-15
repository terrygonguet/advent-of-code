use regex::Regex;

#[derive(Debug)]
struct Sensor {
    pos: (i32, i32),
    beacon: (i32, i32),
    dist: u32,
}

impl Sensor {
    fn parse(str: &str) -> Option<Self> {
        lazy_static! {
            static ref RE: Regex = Regex::new(
                r"(?x)
				Sensor\sat\sx=(?P<x1>-?\d+),\sy=(?P<y1>-?\d+):\s
				closest\sbeacon\sis\sat\sx=(?P<x2>-?\d+),\sy=(?P<y2>-?\d+)"
            )
            .unwrap();
        }
        if let Some(captures) = RE.captures(str) {
            let x1 = captures["x1"].parse::<i32>().unwrap();
            let y1 = captures["y1"].parse::<i32>().unwrap();
            let x2 = captures["x2"].parse::<i32>().unwrap();
            let y2 = captures["y2"].parse::<i32>().unwrap();
            Some(Self {
                pos: (x1, y1),
                beacon: (x2, y2),
                dist: x1.abs_diff(x2) + y1.abs_diff(y2),
            })
        } else {
            None
        }
    }

    fn xmax(&self) -> i32 {
        self.pos.0 + self.dist as i32
    }

    fn xmin(&self) -> i32 {
        self.pos.0 - self.dist as i32
    }

    fn is_covered(&self, pos: (i32, i32)) -> bool {
        if self.beacon != pos {
            self.pos.0.abs_diff(pos.0) + self.pos.1.abs_diff(pos.1) <= self.dist
        } else {
            false
        }
    }
}

pub fn solution(puzzle: &String, test_row: i32) -> String {
    let sensors: Vec<Sensor> = puzzle
        .lines()
        .flat_map(|line| Sensor::parse(line))
        .collect();
    let xmax = sensors.iter().map(|s| s.xmax()).max().unwrap();
    let xmin = sensors.iter().map(|s| s.xmin()).min().unwrap();

    let mut total = 0;
    for x in xmin..=xmax {
        let pos = (x, test_row);
        if sensors.iter().any(|s| s.is_covered(pos)) {
            total += 1;
        }
    }
    total.to_string()
}
