use std::{cell::RefCell, cmp::Ordering, collections::HashMap, ops::Div};

use regex::Regex;

#[derive(Debug, Clone)]
enum Op {
    Add(i32),
    Mult(i32),
    Square,
}

impl Op {
    fn parse(str: &str) -> Option<Self> {
        let parts: Vec<&str> = str.split_whitespace().collect();
        match parts[..] {
            ["new", "=", "old", "*", "old"] => Some(Self::Square),
            ["new", "=", "old", "+", num] => Some(Self::Add(num.parse().unwrap())),
            ["new", "=", "old", "*", num] => Some(Self::Mult(num.parse().unwrap())),
            _ => None,
        }
    }

    fn run(&self, a: i32) -> i32 {
        match self {
            Self::Square => a * a,
            Self::Add(b) => a + b,
            Self::Mult(b) => a * b,
        }
    }
}

#[derive(Debug, Clone)]
struct Monkey {
    id: i32,
    items: Vec<i32>,
    operation: Op,
    test: i32,
    throw_true: i32,
    throw_false: i32,
    num_inspected: i32,
}

impl Monkey {
    fn parse(str: &str) -> Option<Self> {
        lazy_static! {
            static ref RE: Regex = Regex::new(
                r"(?x)
				Monkey\s(?P<id>\d+):\s+
				Starting\sitems:\s(?P<items>.+)\s+
				Operation:\s(?P<op>.+)\s+
				Test:\sdivisible\sby\s(?P<test>.+)\s+
				If\strue:\sthrow\sto\smonkey\s(?P<throw_true>\d+)\s+
				If\sfalse:\sthrow\sto\smonkey\s(?P<throw_false>\d+)"
            )
            .unwrap();
        }
        if let Some(captures) = RE.captures(str) {
            let id = captures["id"].parse::<i32>().unwrap();
            let items = captures["items"]
                .split(", ")
                .map(|str| str.parse().unwrap())
                .collect::<Vec<i32>>();
            let operation = Op::parse(&captures["op"]).unwrap();
            let test = captures["test"].parse::<i32>().unwrap();
            let throw_true = captures["throw_true"].parse::<i32>().unwrap();
            let throw_false = captures["throw_false"].parse::<i32>().unwrap();

            Some(Self {
                id,
                items,
                operation,
                test,
                throw_false,
                throw_true,
                num_inspected: 0,
            })
        } else {
            None
        }
    }

    fn run(&mut self, throw_true: &RefCell<Monkey>, throw_false: &RefCell<Monkey>) {
        for item in self.items.iter() {
            self.num_inspected += 1;
            let next = self.operation.run(*item).div(3);
            if next % self.test == 0 {
                throw_true.borrow_mut().items.push(next);
            } else {
                throw_false.borrow_mut().items.push(next);
            };
        }
        self.items.clear();
    }
}

impl Ord for Monkey {
    fn cmp(&self, other: &Self) -> Ordering {
        self.id.cmp(&other.id)
    }
}

impl PartialOrd for Monkey {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Monkey {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id
    }
}

impl Eq for Monkey {}

pub fn solution(puzzle: &String) -> String {
    let mut circus = HashMap::new();
    for block in puzzle.split("\n\n") {
        if let Some(monkey) = Monkey::parse(block) {
            circus.insert(monkey.id, RefCell::new(monkey));
        }
    }

    let mut sorted = circus.values().collect::<Vec<&RefCell<Monkey>>>();
    sorted.sort();
    for _ in 0..20 {
        for monkey in sorted.iter() {
            let mut monkey = monkey.borrow_mut();
            let throw_true = &circus[&monkey.throw_true];
            let throw_false = &circus[&monkey.throw_false];
            monkey.run(throw_true, throw_false);
        }
    }

    let mut inspected: Vec<i32> = sorted
        .iter()
        .map(|monkey| monkey.borrow().num_inspected)
        .collect();
    inspected.sort();
    inspected.reverse();
    match inspected[0..2] {
        [a, b] => a * b,
        _ => 0,
    }
    .to_string()
}
