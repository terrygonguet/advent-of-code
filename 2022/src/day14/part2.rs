use std::{cmp::Ordering, collections::HashMap};

use iterwindows::IterArrayWindows;

#[derive(Eq, PartialEq, Hash, Debug)]
struct Pos(i32, i32);

impl Pos {
    fn parse(str: &str) -> Option<Self> {
        let mut parts = str.split(",");
        let x = parts.next().map(|x| x.parse::<i32>().unwrap());
        let y = parts.next().map(|x| x.parse::<i32>().unwrap());
        match (x, y) {
            (Some(x), Some(y)) => Some(Self(x, y)),
            _ => None,
        }
    }
}

impl Ord for Pos {
    fn cmp(&self, other: &Self) -> Ordering {
        let &Pos(x1, y1) = self;
        let &Pos(x2, y2) = other;
        if y1 == y2 {
            x1.cmp(&x2)
        } else {
            y1.cmp(&y2)
        }
    }
}

impl PartialOrd for Pos {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

enum Matter {
    Sand,
    Stone,
}

pub fn solution(puzzle: &String) -> String {
    let mut world = HashMap::new();
    for line in puzzle.lines() {
        let mut path = vec![];
        for point in line.split(" -> ") {
            if let Some(pos) = Pos::parse(point) {
                path.push(pos);
            }
        }
        for [a, b] in path.iter().array_windows() {
            let &Pos(x1, y1) = a;
            let &Pos(x2, y2) = b;
            let xmin = i32::min(x1, x2);
            let xmax = i32::max(x1, x2);
            let ymin = i32::min(y1, y2);
            let ymax = i32::max(y1, y2);
            for x in xmin..=xmax {
                for y in ymin..=ymax {
                    world.insert(Pos(x, y), Matter::Stone);
                }
            }
        }
    }

    let &Pos(_, maxy) = world.keys().max().unwrap();
    for x in (-maxy)..(1000 + maxy) {
        world.insert(Pos(x, maxy + 2), Matter::Stone);
    }

    let mut num_particles = 0;
    loop {
        if !simulate_particle(&mut world) {
            break;
        }
        num_particles += 1;
    }

    num_particles.to_string()
}

fn simulate_particle(world: &mut HashMap<Pos, Matter>) -> bool {
    let mut x = 500;
    let mut y = 0;
    if world.get(&Pos(x, y)).is_some() {
        return false;
    }
    loop {
        if let None = world.get(&Pos(x, y + 1)) {
            y += 1;
            continue;
        }
        if let None = world.get(&Pos(x - 1, y + 1)) {
            y += 1;
            x -= 1;
            continue;
        }
        if let None = world.get(&Pos(x + 1, y + 1)) {
            y += 1;
            x += 1;
            continue;
        }
        world.insert(Pos(x, y), Matter::Sand);
        return true;
    }
}
