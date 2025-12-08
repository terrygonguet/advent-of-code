defmodule Day08 do
  def parse_pos(str) do
    String.split(str, ",") |> Enum.map(fn digits -> Integer.parse(digits) |> elem(0) end) |> List.to_tuple()
  end

  def sqr_dist(a, b) do
    dx = elem(a, 0) - elem(b, 0)
    dy = elem(a, 1) - elem(b, 1)
    dz = elem(a, 2) - elem(b, 2)
    dx * dx + dy * dy + dz * dz
  end

  defmodule Part1 do
    def solve(str) do
      boxes = String.split(str, "\n") |> Enum.map(&Day08.parse_pos/1)
      pairs = Enum.with_index(boxes) |> Enum.flat_map(fn {a, i} ->
        Enum.map(Enum.drop(boxes, i + 1), fn b -> {a, b, Day08.sqr_dist(a, b)} end)
      end)
      pairs = Enum.sort_by(pairs, &elem(&1, 2))
      num_steps = if length(boxes) == 20, do: 10, else: 1000
      circuits = Enum.reduce(Enum.take(pairs, num_steps), [], fn {a, b, _dist}, circuits ->
        a_idx = Enum.find_index(circuits, fn circuit -> a in circuit end)
        b_idx = Enum.find_index(circuits, fn circuit -> b in circuit end)
        cond do
          a_idx == nil and b_idx == nil -> [[a, b] | circuits]
          a_idx == b_idx -> circuits
          b_idx == nil -> List.update_at(circuits, a_idx, fn circuit -> [b | circuit] end)
          a_idx == nil -> List.update_at(circuits, b_idx, fn circuit -> [a | circuit] end)
          true -> b_circuit = Enum.at(circuits, b_idx)
            new_circuits = List.update_at(circuits, a_idx, fn a_circuit -> Enum.concat(a_circuit, b_circuit) end)
            List.delete_at(new_circuits, b_idx) |> Enum.uniq()
        end
      end)
      Enum.map(circuits, &length/1) |> Enum.sort(:desc) |> Enum.take(3) |> Enum.product()
    end
  end

  defmodule Part2 do
    def solve(str) do
      boxes = String.split(str, "\n") |> Enum.map(&Day08.parse_pos/1)
      pairs = Enum.with_index(boxes) |> Enum.flat_map(fn {a, i} ->
        Enum.map(Enum.drop(boxes, i + 1), fn b -> {a, b, Day08.sqr_dist(a, b)} end)
      end)
      pairs = Enum.sort_by(pairs, &elem(&1, 2))
      {_, last_pair} = Enum.reduce_while(pairs, {[], nil}, fn {a, b, _dist}, {circuits, last_pair} ->
        if length(circuits) == 1 and length(hd(circuits)) == length(boxes) do
          {:halt, {circuits, last_pair}}
        else
          a_idx = Enum.find_index(circuits, fn circuit -> a in circuit end)
          b_idx = Enum.find_index(circuits, fn circuit -> b in circuit end)
          cur_pair = {a, b}
          cond do
            a_idx == nil and b_idx == nil -> {:cont, {[[a, b] | circuits], cur_pair}}
            a_idx == b_idx -> {:cont, {circuits, cur_pair}}
            b_idx == nil -> {:cont, {List.update_at(circuits, a_idx, fn circuit -> [b | circuit] end), cur_pair}}
            a_idx == nil -> {:cont, {List.update_at(circuits, b_idx, fn circuit -> [a | circuit] end), cur_pair}}
            true -> b_circuit = Enum.at(circuits, b_idx)
              new_circuits = List.update_at(circuits, a_idx, fn a_circuit -> Enum.concat(a_circuit, b_circuit) end)
              {:cont, {List.delete_at(new_circuits, b_idx) |> Enum.uniq(), cur_pair}}
          end
        end
      end)
      {{x1, _, _}, {x2, _, _}} = last_pair
      x1 * x2
    end
  end
end

IO.puts("--- Puzzle ---")
puzzle = File.read!("day08/puzzle.txt")
IO.puts("Part 1: " <> inspect(Day08.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day08.Part2.solve(puzzle)))
IO.puts("\n")

IO.puts("--- Ex 1 ---")
puzzle = File.read!("day08/ex1.txt")
IO.puts("Part 1: " <> inspect(Day08.Part1.solve(puzzle)))
IO.puts("Part 2: " <> inspect(Day08.Part2.solve(puzzle)))
IO.puts("\n")
