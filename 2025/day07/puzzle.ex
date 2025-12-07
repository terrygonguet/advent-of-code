defmodule Day07 do
  defmodule Part1 do
    def solve(str) do
      [first_line | lines] = String.split(str, "\n")
      beam_start = String.to_charlist(first_line) |> Enum.find_index(fn char -> char == ?S end)
      lines = Enum.filter(lines, fn line -> String.contains?(line, "^") end)
      splitters = Enum.map(lines, fn line ->
        String.to_charlist(line)
          |> Enum.with_index()
          |> Enum.flat_map(fn tuple ->
            case tuple do
              {?^, i} -> [i]
              _ -> []
            end
          end)
      end)
      {beams, num_splits} = Enum.reduce(splitters, {[beam_start], 0}, fn splitters, {beams, num_splits} ->
        new_beams = Enum.flat_map(beams, fn beam ->
          if beam in splitters, do: [beam - 1, beam + 1], else: [beam]
        end)
        new_splits = Enum.count(beams, fn beam -> beam in splitters end)
        {Enum.uniq(new_beams), num_splits + new_splits}
      end)
      num_splits
    end
  end

  defmodule Part2 do
    def solve(str) do
      [first_line | lines] = String.split(str, "\n")
      beams = String.to_charlist(first_line) |> Enum.map(fn char -> if char == ?S, do: 1, else: 0 end)
      lines = Enum.filter(lines, fn line -> String.contains?(line, "^") end)
      splitters = Enum.map(lines, fn line ->
        String.to_charlist(line)
          |> Enum.with_index()
          |> Enum.flat_map(fn tuple ->
            case tuple do
              {?^, i} -> [i]
              _ -> []
            end
          end)
      end)
      final_beams = Enum.reduce(splitters, beams, fn splitters, beams ->
        Enum.with_index(beams) |> Enum.map(fn {num_beams, i} ->
          left = if (i - 1) in splitters, do: Enum.at(beams, i - 1, 0), else: 0
          right = if (i + 1) in splitters, do: Enum.at(beams, i + 1, 0), else: 0
          center = if i in splitters, do: 0, else: num_beams
          left + center + right
        end)
      end)
      Enum.sum(final_beams)
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day07/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day07.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day07.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day07/ex1.txt")
IO.puts("Part 1: " <> inspect(Day07.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day07.Part2.solve(puzzle)))
IO.puts("\n")
