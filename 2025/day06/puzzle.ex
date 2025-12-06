defmodule Day06 do
  defmodule Part1 do
    def solve(str) do
      tuples = String.split(str, "\n") |> Enum.reverse() |> Enum.map(fn line ->
        String.trim(line) |> String.split()
      end) |> Enum.zip()
      Enum.sum_by(tuples, fn tuple ->
        case Tuple.to_list(tuple) do
          ["*" | args] -> Enum.reduce(args, 1, fn digits, sum -> sum * (Integer.parse(digits) |> elem(0)) end)
          ["+" | args] -> Enum.reduce(args, 0, fn digits, sum -> sum + (Integer.parse(digits) |> elem(0)) end)
        end
      end)
    end
  end

  defmodule Part2 do
    def solve(_str) do
      "meh"
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day06/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day06.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day06.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day06/ex1.txt")
IO.puts("Part 1: " <> inspect(Day06.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day06.Part2.solve(puzzle)))
IO.puts("\n")
