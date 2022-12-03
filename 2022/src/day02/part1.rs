enum Move {
    Rock,
    Paper,
    Scissors,
}

impl Move {
    fn parse(char: &str) -> Option<Self> {
        match char {
            "A" => Some(Self::Rock),
            "X" => Some(Self::Rock),
            "B" => Some(Self::Paper),
            "Y" => Some(Self::Paper),
            "C" => Some(Self::Scissors),
            "Z" => Some(Self::Scissors),
            _ => None,
        }
    }

    fn score(&self) -> i32 {
        match self {
            Self::Rock => 1,
            Self::Paper => 2,
            Self::Scissors => 3,
        }
    }
}

struct Round {
    me: Move,
    elf: Move,
}

impl Round {
    fn parse(str: &str) -> Option<Self> {
        let mut iter = str.split_whitespace();
        let elf = iter.next().and_then(Move::parse);
        let me = iter.next().and_then(Move::parse);
        match (me, elf) {
            (Some(me), Some(elf)) => Some(Self { me, elf }),
            _ => None,
        }
    }

    fn score(&self) -> i32 {
        match self {
            Round {
                me: Move::Rock,
                elf: Move::Rock,
            } => self.me.score() + 3,
            Round {
                me: Move::Rock,
                elf: Move::Paper,
            } => self.me.score() + 0,
            Round {
                me: Move::Rock,
                elf: Move::Scissors,
            } => self.me.score() + 6,
            Round {
                me: Move::Paper,
                elf: Move::Rock,
            } => self.me.score() + 6,
            Round {
                me: Move::Paper,
                elf: Move::Paper,
            } => self.me.score() + 3,
            Round {
                me: Move::Paper,
                elf: Move::Scissors,
            } => self.me.score() + 0,
            Round {
                me: Move::Scissors,
                elf: Move::Rock,
            } => self.me.score() + 0,
            Round {
                me: Move::Scissors,
                elf: Move::Paper,
            } => self.me.score() + 6,
            Round {
                me: Move::Scissors,
                elf: Move::Scissors,
            } => self.me.score() + 3,
        }
    }
}

pub fn solution(puzzle: &String) -> String {
    let score = puzzle.lines().map(Round::parse).fold(0, |acc, cur| {
        acc + match cur {
            Some(round) => round.score(),
            None => 0,
        }
    });
    score.to_string()
}
