defmodule Day09 do
  def parse_pos(str) do
    String.split(str, ",") |> Enum.map(fn digits -> Integer.parse(digits) |> elem(0) end) |> List.to_tuple()
  end

  def area(a, b) do
    {x1, y1} = a
    {x2, y2} = b
    (max(x1, x2) - min(x1, x2) + 1) * (max(y1, y2) - min(y1, y2) + 1)
  end

  defmodule Part1 do
    def solve(str) do
      tiles = String.split(str, "\n") |> Enum.map(&Day09.parse_pos/1)
      pairs = Enum.with_index(tiles) |> Enum.flat_map(fn {a, i} ->
        Enum.map(Enum.drop(tiles, i + 1), fn b -> {a, b, Day09.area(a, b)} end)
      end)
      pairs = Enum.sort_by(pairs, &elem(&1, 2), :desc)
      hd(pairs) |> elem(2)
    end
  end

  defmodule Part2 do
    import Bitwise

    def solve(_str) do
      "meh"
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day09/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day09.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day09.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day09/ex1.txt")
IO.puts("Part 1: " <> inspect(Day09.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day09.Part2.solve(puzzle)))
IO.puts("\n")
