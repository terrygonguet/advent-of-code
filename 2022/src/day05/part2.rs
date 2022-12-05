use std::cell::RefCell;

#[derive(Debug)]
struct Ship<'a> {
    num_cols: usize,
    cols: Vec<RefCell<Vec<&'a str>>>,
}

impl<'a> Ship<'a> {
    fn parse(str: &'a str) -> Option<Self> {
        let mut lines = str.lines().rev();
        if let Some(num_cols) = lines
            .next()
            .and_then(|line| line.split_whitespace().rev().next())
            .and_then(|char| {
                if let Ok(num_cols) = char.parse::<usize>() {
                    Some(num_cols)
                } else {
                    None
                }
            })
        {
            let mut cols: Vec<RefCell<Vec<&'a str>>> = Vec::new();
            for n in 0..num_cols {
                cols.push(RefCell::from(Vec::new()));
            }
            for line in lines {
                let mut i = 1;
                for n in 0..num_cols {
                    let char = line.get(i..=i);
                    i += 4;
                    match char {
                        None => (),
                        Some(" ") => (),
                        Some(char) => (*cols).get_mut(n).unwrap().borrow_mut().push(char),
                    }
                }
            }
            Some(Self { num_cols, cols })
        } else {
            None
        }
    }

    fn apply(&mut self, action: &Action) {
        println!(
            "Apply move {} from {} to {}",
            action.num, action.from, action.to
        );
        let mut from = self.cols[action.from].borrow_mut();
        let mut to = self.cols[action.to].borrow_mut();
        let mut crane = vec![];
        for n in 0..action.num {
            let char = from.pop();
            match char {
                Some(char) => crane.insert(0, char),
                None => (),
            }
        }
        to.append(&mut crane);
    }

    fn result(&self) -> String {
        self.cols.iter().fold(String::new(), |mut acc, cur| {
            acc.push_str(cur.borrow().last().unwrap_or(&""));
            acc
        })
    }
}

#[derive(Debug)]
struct Action {
    num: usize,
    from: usize,
    to: usize,
}

impl Action {
    fn parse(str: &str) -> Option<Self> {
        let numbers: Vec<usize> = str
            .replace("move", "")
            .replace("from", "")
            .replace("to", "")
            .split_whitespace()
            .map(|n| n.parse::<usize>().unwrap())
            .collect();
        Some(Self {
            num: numbers[0],
            from: numbers[1] - 1,
            to: numbers[2] - 1,
        })
    }
}

pub fn solution(puzzle: &String) -> String {
    let mut parts = puzzle.split("\n\n");
    let mut ship = Ship::parse(parts.next().unwrap()).unwrap();
    let actions: Vec<Action> = parts
        .next()
        .unwrap()
        .lines()
        .map(|line| Action::parse(line).unwrap())
        .collect();
    println!("{:?}", ship);
    for action in actions {
        ship.apply(&action);
    }
    println!("{:?}", ship);
    ship.result().to_string()
}
