defmodule Day05 do
  defmodule Part1 do
    def solve(str) do
      [ranges, ids] = String.split(str, "\n\n")
      ranges = String.split(ranges, "\n") |> Enum.map(fn line ->
        [first, last] = String.split(line, "-") |> Enum.map(fn digits -> Integer.parse(digits) |> elem(0) end)
        Range.new(first, last)
      end)
      ranges = Enum.sort(ranges, fn a, b ->
        if a.first == b.first, do: a.last <= b.last, else: a.first < b.first
      end)
      ids = String.split(ids, "\n") |> Enum.map(fn digits -> Integer.parse(digits) |> elem(0) end)
      Enum.filter(ids, fn id -> Enum.any?(ranges, fn range -> id >= range.first and id <= range.last end) end) |> length()
    end
  end

  defmodule Part2 do
    def process_ranges(ranges) do
      [first | ranges] = Enum.sort(ranges, fn a, b ->
        if a.first == b.first, do: a.last <= b.last, else: a.first < b.first
      end)
      {ranges, last} = Enum.reduce(ranges, {[], first}, fn cur, {list, acc} ->
        if Range.disjoint?(cur, acc) do
          {[acc | list], cur}
        else
          {list, Range.new(min(acc.first, cur.first), max(acc.last, cur.last))}
        end
      end)
      [last | ranges]
    end

    def solve(str) do
      [ranges, _] = String.split(str, "\n\n")
      ranges = String.split(ranges, "\n") |> Enum.map(fn line ->
        [first, last] = String.split(line, "-") |> Enum.map(fn digits -> Integer.parse(digits) |> elem(0) end)
        Range.new(first, last)
      end)
      ranges = process_ranges(ranges)
      Enum.sum_by(ranges, &Range.size/1)
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day05/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day05.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day05.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day05/ex1.txt")
IO.puts("Part 1: " <> inspect(Day05.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day05.Part2.solve(puzzle)))
IO.puts("\n")
