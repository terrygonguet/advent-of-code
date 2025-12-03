defmodule Day03 do
  defmodule Part1 do
    def solve(str) do
      pairs = String.split(str, "\n", trim: true) |> Enum.map(fn str ->
        Integer.parse(str) |> elem(0) |> Integer.digits() |> Enum.reduce({0, 0}, fn cur, acc ->
          {d1, d2} = acc
          acc_sum = d1 * 10 + d2
          candidate1 = d1 * 10 + cur
          candidate2 = d2 * 10 + cur
          cond do
            candidate1 > acc_sum and candidate1 > candidate2 -> {d1, cur}
            candidate2 > acc_sum -> {d2, cur}
            true -> acc
          end
        end)
      end)
      Enum.reduce(pairs, 0, fn {d1, d2}, sum -> sum + d1 * 10 + d2 end)
    end
  end

  defmodule Part2 do
    def solve(str) do
      tuples = String.split(str, "\n", trim: true) |> Enum.map(fn line ->
        Integer.parse(line) |> elem(0) |> Integer.digits() |> Enum.reduce(List.duplicate(0, 12), fn cur, digits ->
          candidates = digits ++ [cur]
          Enum.map(0..12, fn i -> List.delete_at(candidates, i) end) |> Enum.max_by(&Integer.undigits/1)
        end)
      end)
      Enum.reduce(tuples, 0, fn digits, sum -> sum + Integer.undigits(digits) end)
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day03/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day03.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day03.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day03/ex1.txt")
IO.puts("Part 1: " <> inspect(Day03.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day03.Part2.solve(puzzle)))
IO.puts("\n")
