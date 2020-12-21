import { last, sum } from "../tools.ts"

type Expression =
	| {
			right: Expression
			left: Expression
			operator: "+" | "*"
	  }
	| number
type Token = number | "+" | "*" | "(" | ")"

export default function (input: string) {
	const lines = input.split("\n"),
		expressions = lines.map(tokenize).map(parse)

	return sum(expressions.map(evaluate))
}

function evaluate(expr: Expression): number {
	if (typeof expr == "number") return expr
	else if (expr.operator == "+") return evaluate(expr.left) + evaluate(expr.right)
	else if (expr.operator == "*") return evaluate(expr.left) * evaluate(expr.right)
	else throw new Error("Cannot happen...")
}

function tokenize(str: string) {
	return str
		.split("")
		.filter(t => t != " ")
		.map(t => parseInt(t) || t) as Token[]
}

function parse(tokens: Token[]): Expression {
	if (tokens.length == 0) throw new Error("Got no tokens to parse")
	else if (tokens.length == 1) return tokens[0] as number
	if (last(tokens) == ")") {
		let open = 1,
			end = 0
		for (let i = tokens.length - 2; i > 0; i--) {
			if (tokens[i] == ")") open++
			else if (tokens[i] == "(") open--

			if (open == 0) {
				end = i
				break
			}
		}

		if (end == 0) {
			return parse(tokens.slice(1, -1))
		} else {
			return {
				left: parse(tokens.slice(0, end - 1)),
				operator: tokens[end - 1] as "+" | "*",
				right: parse(tokens.slice(end)),
			}
		}
	} else {
		return {
			left: parse(tokens.slice(0, -2)),
			operator: tokens[tokens.length - 2] as "+" | "*",
			right: last(tokens) as number,
		}
	}
}
