use std::cmp::Ordering;

#[derive(PartialEq, Eq, Clone)]
enum Packet {
    Int(u32),
    List(Vec<Packet>),
}

impl Packet {
    fn parse(str: &str) -> Option<Self> {
        let mut stack = vec![];
        for (i, char) in str.chars().enumerate() {
            match char {
                '[' => stack.push(vec![]),
                ']' => {
                    let vec = stack.pop().unwrap();
                    if let Some(container) = stack.last_mut() {
                        container.push(Packet::List(vec));
                    } else {
                        return Some(Packet::List(vec));
                    }
                }
                ',' => (),
                _ => {
                    let mut j = i;
                    let mut num = 0;
                    loop {
                        j += 1;
                        if let Ok(result) = str[i..j].parse::<u32>() {
                            num = result;
                        } else {
                            break;
                        }
                    }
                    if let Some(container) = stack.last_mut() {
                        container.push(Packet::Int(num));
                    }
                }
            }
        }
        None
    }
}

impl PartialOrd for Packet {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Packet {
    fn cmp(&self, other: &Self) -> Ordering {
        match (self, other) {
            (Self::Int(a), Self::Int(b)) => a.cmp(b),
            (Self::Int(_), Self::List(_)) => Self::List(vec![self.clone()]).cmp(other),
            (Self::List(_), Self::Int(_)) => self.cmp(&Self::List(vec![other.clone()])),
            (Self::List(a), Self::List(b)) => {
                for (a, b) in a.iter().zip(b.iter()) {
                    let ord = a.cmp(b);
                    if ord.is_ne() {
                        return ord;
                    }
                }
                a.len().cmp(&b.len())
            }
        }
    }
}

pub fn solution(puzzle: &String) -> String {
    let sep_1 = Packet::parse("[[2]]").unwrap();
    let sep_2 = Packet::parse("[[6]]").unwrap();
    let mut packets: Vec<Packet> = puzzle
        .replace("\n\n", "\n")
        .lines()
        .map(|line| Packet::parse(line).unwrap())
        .collect();
    packets.push(sep_1.clone());
    packets.push(sep_2.clone());
    packets.sort();

    let mut total = 1;
    for (i, packet) in packets.iter().enumerate() {
        if *packet == sep_1 || *packet == sep_2 {
            total *= i + 1;
        }
    }

    total.to_string()
}
