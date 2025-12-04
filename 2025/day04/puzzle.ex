defmodule Day04 do
  def empty?(grid, x, y, w, h) do
    if x < 0 or x >= w or y < 0 or y >= h do
      true
    else
      :binary.at(grid, x + y * w) == ?.
    end
  end

  def count_neighbours(grid, x, y, w, h) do
    if empty?(grid, x, y, w, h) do
      9
    else
      [
        (if empty?(grid, x - 1, y - 1, w, h), do: 0, else: 1),
        (if empty?(grid, x    , y - 1, w, h), do: 0, else: 1),
        (if empty?(grid, x + 1, y - 1, w, h), do: 0, else: 1),
        (if empty?(grid, x - 1, y    , w, h), do: 0, else: 1),
        (if empty?(grid, x + 1, y    , w, h), do: 0, else: 1),
        (if empty?(grid, x - 1, y + 1, w, h), do: 0, else: 1),
        (if empty?(grid, x    , y + 1, w, h), do: 0, else: 1),
        (if empty?(grid, x + 1, y + 1, w, h), do: 0, else: 1),
      ] |> Enum.sum()
    end
  end

  def compute_neighbours(str) do
    lines = String.split(str, "\n", trim: true) |> Enum.map(fn line -> String.to_charlist(line) end)
    h = length(lines)
    w = hd(lines) |> length()
    grid = String.replace(str, "\n", "")
    neighbours = Enum.with_index(lines) |> Enum.map(fn {line, y} ->
      Enum.with_index(line) |> Enum.map(fn {_, x} -> Day04.count_neighbours(grid, x, y, w, h) end)
    end)
    {neighbours, Enum.concat(neighbours) |> Enum.count(fn n -> n < 4 end)}
  end

  def neighbours_to_str(neighbours) do
    Enum.map(neighbours, fn row ->
      Enum.map(row, fn n -> if n == 9 or n < 4, do: ?., else: ?@ end)
    end) |> Enum.join("\n")
  end

  defmodule Part1 do
    def solve(str) do
      Day04.compute_neighbours(str) |> elem(1)
    end
  end

  defmodule Part2 do
    def solve(str) do
      Enum.reduce_while(1..100, {str, 0}, fn _, {str, sum} ->
        {neighbours, n} = Day04.compute_neighbours(str)
        if n == 0 do
          {:halt, sum + n}
        else
          {:cont, {Day04.neighbours_to_str(neighbours), sum + n}}
        end
      end)
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day04/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day04.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day04.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day04/ex1.txt")
IO.puts("Part 1: " <> inspect(Day04.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day04.Part2.solve(puzzle)))
IO.puts("\n")
