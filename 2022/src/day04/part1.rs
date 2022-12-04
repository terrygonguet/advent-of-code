struct Range {
    start: i32,
    end: i32,
}

impl Range {
    fn parse(str: &str) -> Option<Self> {
        let mut parts = str.split("-");
        let start = parts.next().and_then(|s| {
            if let Ok(num) = s.parse::<i32>() {
                Some(num)
            } else {
                None
            }
        });
        let end = parts.next().and_then(|s| {
            if let Ok(num) = s.parse::<i32>() {
                Some(num)
            } else {
                None
            }
        });
        match (start, end) {
            (Some(start), Some(end)) => Some(Self { start, end }),
            _ => None,
        }
    }
}

struct Pair {
    first: Range,
    second: Range,
}

impl Pair {
    fn parse(str: &str) -> Option<Self> {
        let mut parts = str.split(",");
        let first = parts.next().and_then(Range::parse);
        let second = parts.next().and_then(Range::parse);
        match (first, second) {
            (Some(first), Some(second)) => Some(Self { first, second }),
            _ => None,
        }
    }

    fn is_contained(&self) -> bool {
        (self.first.start <= self.second.start && self.first.end >= self.second.end)
            || (self.second.start <= self.first.start && self.second.end >= self.first.end)
    }
}

pub fn solution(puzzle: &String) -> String {
    let mut contained = 0;
    for line in puzzle.lines() {
        let pair = Pair::parse(line);
        match pair {
            Some(pair) => {
                if pair.is_contained() {
                    contained += 1
                }
            }
            _ => (),
        };
    }

    contained.to_string()
}
