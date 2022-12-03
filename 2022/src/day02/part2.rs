enum Move {
    Rock,
    Paper,
    Scissors,
}

impl Move {
    fn parse(char: &str) -> Option<Self> {
        match char {
            "A" => Some(Self::Rock),
            "B" => Some(Self::Paper),
            "C" => Some(Self::Scissors),
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

enum Outcome {
    Win,
    Draw,
    Lose,
}

impl Outcome {
    fn parse(char: &str) -> Option<Self> {
        match char {
            "X" => Some(Self::Lose),
            "Y" => Some(Self::Draw),
            "Z" => Some(Self::Win),
            _ => None,
        }
    }

    fn score(&self) -> i32 {
        match self {
            Self::Win => 6,
            Self::Draw => 3,
            Self::Lose => 0,
        }
    }
}

struct Round {
    elf: Move,
    outcome: Outcome,
}

impl Round {
    fn parse(str: &str) -> Option<Self> {
        let mut iter = str.split_whitespace();
        let elf = iter.next().and_then(Move::parse);
        let outcome = iter.next().and_then(Outcome::parse);
        match (outcome, elf) {
            (Some(outcome), Some(elf)) => Some(Self { elf, outcome }),
            _ => None,
        }
    }

    fn score(&self) -> i32 {
        match self {
            Round {
                elf: Move::Rock,
                outcome: Outcome::Win,
            } => Move::Paper.score() + self.outcome.score(),
            Round {
                elf: Move::Rock,
                outcome: Outcome::Draw,
            } => Move::Rock.score() + self.outcome.score(),
            Round {
                elf: Move::Rock,
                outcome: Outcome::Lose,
            } => Move::Scissors.score() + self.outcome.score(),
            Round {
                elf: Move::Paper,
                outcome: Outcome::Win,
            } => Move::Scissors.score() + self.outcome.score(),
            Round {
                elf: Move::Paper,
                outcome: Outcome::Draw,
            } => Move::Paper.score() + self.outcome.score(),
            Round {
                elf: Move::Paper,
                outcome: Outcome::Lose,
            } => Move::Rock.score() + self.outcome.score(),
            Round {
                elf: Move::Scissors,
                outcome: Outcome::Win,
            } => Move::Rock.score() + self.outcome.score(),
            Round {
                elf: Move::Scissors,
                outcome: Outcome::Draw,
            } => Move::Scissors.score() + self.outcome.score(),
            Round {
                elf: Move::Scissors,
                outcome: Outcome::Lose,
            } => Move::Paper.score() + self.outcome.score(),
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
