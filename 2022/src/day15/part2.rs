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

    fn is_covered(&self, pos: &(i32, i32)) -> bool {
        self.pos.0.abs_diff(pos.0) + self.pos.1.abs_diff(pos.1) <= self.dist
    }
}

pub fn solution(puzzle: &String, max_coord: i32) -> String {
    let sensors: Vec<Sensor> = puzzle
        .lines()
        .flat_map(|line| Sensor::parse(line))
        .collect();

    let mut x = 0;
    let mut y = 0;
    let mut found = false;
    for (i, sensor) in sensors.iter().enumerate().cycle() {
        if i == 0 {
            if found {
                break;
            } else {
                found = true;
            }
        }
        if sensor.is_covered(&(x, y)) {
            // println!("{x} {y}");
            found = false;
            let &Sensor {
                pos: (sx, sy),
                beacon: _,
                dist,
            } = sensor;
            let deltax = x - sx;
            let deltay = sy.abs_diff(y);
            x += 1 + (dist - deltay) as i32 - deltax;
        }
        if x > max_coord {
            x = 0;
            y += 1;
        }
        if y > max_coord {
            return 0.to_string();
        }
    }

    // result is too big for i32 and I can't be bothered to refactor
    // just run x * 4000000 + y in Wolfram Alpha
    format!("{x} {y}")
}
