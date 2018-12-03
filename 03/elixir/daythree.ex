defmodule DayThree do
  def partone do
    {map, _} = build_map(read_input())

    Enum.reduce(map, 0, fn {_, row}, acc1 ->
      acc1 +
        Enum.reduce(row, 0, fn {_, cell}, acc2 -> if cell == 'X', do: acc2 + 1, else: acc2 end)
    end)
  end

  def parttwo do
    {_, overlap} = build_map(read_input())
    {index, _} = Enum.find(overlap, fn {_, stat} -> !stat end)
    index
  end

  defp build_map(input) do
    initial_map = Map.new(0..1000, fn x -> {x, Map.new(0..1000, fn y -> {y, 0} end)} end)
    initial_overlap = Map.new(1..length(input), fn x -> {x, nil} end)

    Enum.reduce(input, {initial_map, initial_overlap}, fn [id, x, y, x_range, y_range], acc1 ->
      Enum.reduce(x..(x + x_range - 1), acc1, fn a, acc2 ->
        Enum.reduce(y..(y + y_range - 1), acc2, fn b, {map, overlap} ->
          if map[a][b] != 0 do
            updated_overlap =
              if is_integer(map[a][b]) do
                %{overlap | id => true, map[a][b] => true}
              else
                %{overlap | id => true}
              end

            {Map.update!(map, a, &%{&1 | b => 'X'}), updated_overlap}
          else
            {Map.update!(map, a, &%{&1 | b => id}), overlap}
          end
        end)
      end)
    end)
  end

  defp read_input do
    "../input"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Regex.run(~r/#(\d*) @ (\d*),(\d*): (\d*)x(\d*)/, &1, capture: :all_but_first))
    |> Enum.map(&Enum.map(&1, fn a -> String.to_integer(a) end))
  end
end

# DRIVER
IO.puts(DayThree.partone())
IO.puts(DayThree.parttwo())
