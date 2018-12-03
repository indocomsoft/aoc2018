defmodule Twice do
  def find_dup(list, state \\ {0, MapSet.new([0])}) do
    case find_dup_iter(list, state) do
      {:ok, x} -> x
      {:error, new_state} -> find_dup(list, new_state)
    end
  end

  defp find_dup_iter([], state), do: {:error, state}

  defp find_dup_iter([x | xs], {sum, state}) do
    new_sum = sum + x
    if MapSet.member?(state, new_sum) do
      {:ok, new_sum}
    else
      find_dup_iter(xs, {new_sum, MapSet.put(state, new_sum)})
    end
  end
end

"../input"
|> File.stream!()
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)
|> Twice.find_dup()
|> IO.puts()
