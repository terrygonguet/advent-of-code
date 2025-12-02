defmodule Day01Part1 do
  def solve(str) do
    rotations = String.split(str, "\n") |> Enum.map(&parse_rotation/1)
    safe = Enum.reduce(rotations, %{position: 50, sum: 0}, fn rotation, acc ->
      new_pos = Integer.mod(acc.position + rotation, 100)
      new_sum = if new_pos == 0, do: acc.sum + 1, else: acc.sum
      %{position: new_pos, sum: new_sum}
    end)
    safe.sum
  end

  def parse_rotation(str) do
    case str do
      "L" <> num ->
        case Integer.parse(num) do
          {n, _} -> -n
        end
      "R" <> num ->
        case Integer.parse(num) do
          {n, _} -> n
        end
    end
  end
end

defmodule Day01Part2 do
  def solve(str) do
    rotations = String.split(str, "\n") |> Enum.map(&Day01Part1.parse_rotation/1)
    safe = Enum.reduce(rotations, %{pos: 50, sum: 0}, fn rotation, acc ->
      new_pos = acc.pos + rotation
      new_sum = acc.sum + cond do
        rem(new_pos, 100) == 0 and new_pos <= 0 -> abs(floor(new_pos / 100)) + 1
        acc.pos == 0 and new_pos <= 0 -> abs(floor(new_pos / 100)) - 1
        true -> abs(floor(new_pos / 100))
      end
      %{pos: Integer.mod(new_pos, 100), sum: new_sum}
    end)
    safe.sum
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day01/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day01Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day01Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day01/ex1.txt")
IO.puts("Part 1: " <> inspect(Day01Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day01Part2.solve(puzzle)))
IO.puts("\n")
