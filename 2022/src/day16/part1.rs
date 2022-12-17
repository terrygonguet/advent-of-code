use std::collections::HashMap;

use regex::Regex;

#[derive(Debug)]
struct Valve {
    name: String,
    flow: i32,
    tunnels: Vec<String>,
}

impl Valve {
    fn parse(str: &str) -> Option<Valve> {
        lazy_static! {
            static ref RE: Regex = Regex::new(
                r"(?x)
				Valve\s(?P<name>.+)\s
				has\sflow\srate=(?P<flow>\d+);\s
				tunnels?\sleads?\sto\svalves?\s(?P<tunnels>.+)"
            )
            .unwrap();
        }
        if let Some(captures) = RE.captures(str) {
            let name = captures["name"].to_string();
            let flow = captures["flow"].parse::<i32>().unwrap();
            let tunnels: Vec<String> = captures["tunnels"]
                .split(", ")
                .map(|s| s.to_string())
                .collect();
            Some(Self {
                name,
                flow,
                tunnels,
            })
        } else {
            None
        }
    }
}

#[derive(Debug, Clone)]
enum Action {
    Move(String),
    Open(String),
    Idle,
}

pub fn solution(puzzle: &String) -> String {
    let mut graph = HashMap::new();
    for line in puzzle.lines() {
        if let Some(valve) = Valve::parse(line) {
            graph.insert(valve.name.clone(), valve);
        } else {
            println!("{line}");
        }
    }
    solve(&graph, vec![], 0).to_string()
}

fn solve(graph: &HashMap<String, Valve>, actions: Vec<Action>, score: i32) -> i32 {
    let n = actions.len() as i32;
    // println!("{actions:?} {score}");
    if n >= 30 {
        score
    } else {
        let mut max_score = score;
        let valve_name = &cur_valve_name(&actions);
        let valve = &graph[valve_name];
        if valve.flow > 0 && !is_open(valve_name, &actions) {
            let mut actions = actions.clone();
            actions.push(Action::Open(valve_name.clone()));
            max_score = max_score.max(solve(graph, actions, score + (30 - n - 1) * valve.flow));
        }
        for next in valve.tunnels.iter() {
            let mut actions = actions.clone();
            actions.push(Action::Move(next.clone()));
            max_score = max_score.max(solve(graph, actions, score));
        }
        let mut actions = actions.clone();
        actions.push(Action::Idle);
        max_score = max_score.max(solve(graph, actions, score));
        max_score
    }
}

fn is_open(needle: &String, haystack: &Vec<Action>) -> bool {
    haystack.iter().any(|a| match a {
        Action::Open(to) => needle == to,
        _ => false,
    })
}

fn cur_valve_name(actions: &Vec<Action>) -> String {
    for action in actions.iter().rev() {
        if let Action::Move(name) = action {
            return name.clone();
        }
    }
    "AA".to_string()
}
