defmodule Day02 do
  require Integer

  def parse_ranges(str) do
    String.split(str, ",", trim: true) |> Enum.map(fn str ->
      [{low, _}, {high, _}] = String.split(str, "-", trim: true) |> Enum.map(&Integer.parse/1)
      Range.new(low, high)
    end)
  end

  defmodule Part1 do
    def solve(str) do
      ranges = Day02.parse_ranges(str)
      invalid = Enum.reduce(ranges, [], fn range, acc ->
        acc ++ Enum.filter(range, &invalid?/1)
      end)
      Enum.sum(invalid)
    end

    def invalid?(num) do
      str = Integer.to_string(num)
      if Integer.is_even(byte_size(str)) do
        len = div(byte_size(str), 2)
        pattern = binary_slice(str, 0, len)
        String.count(str, pattern) == 2
      else
        false
      end
    end
  end

  defmodule Part2 do
    def solve(str) do
      ranges = Day02.parse_ranges(str)
      invalid = Enum.reduce(ranges, [], fn range, acc ->
        acc ++ Enum.filter(range, &invalid?/1)
      end)
      Enum.sum(invalid)
    end

    def invalid?(num) do
      str = Integer.to_string(num)
      len = byte_size(str)
      if len >= 2 do
        Enum.any?(1..div(len, 2), fn pattern_len ->
          num_copies = String.count(str, binary_slice(str, 0, pattern_len))
          num_copies * pattern_len == len
        end)
      else
        false
      end
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day02/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day02.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day02.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day02/ex1.txt")
IO.puts("Part 1: " <> inspect(Day02.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day02.Part2.solve(puzzle)))
IO.puts("\n")
