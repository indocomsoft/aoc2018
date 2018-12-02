defmodule DayTwo do
  def partone do
    lines_freqs = Enum.map(read_input(), &letter_frequency/1)

    twos =
      lines_freqs
      |> Enum.filter(&Enum.any?(&1, fn {_, freq} -> freq == 2 end))
      |> length

    threes =
      lines_freqs
      |> Enum.filter(&Enum.any?(&1, fn {_, freq} -> freq == 3 end))
      |> length

    twos * threes
  end

  def parttwo do
    data = read_input()

    data
    |> Stream.map(fn x ->
      data
      |> Stream.map(fn y -> find_one_different(x, y) end)
      |> first_non_nil_from_stream()
    end)
    |> first_non_nil_from_stream()
  end

  defp first_non_nil_from_stream(stream) do
    stream |> Stream.filter(& &1) |> Stream.take(1) |> Enum.at(0)
  end

  defp find_one_different(x, y) do
    same =
      x
      |> String.graphemes()
      |> Enum.zip(String.graphemes(y))
      |> Enum.filter(fn {a, b} -> a == b end)
      |> Enum.map(fn {a, _} -> a end)
      |> Enum.join()

    if String.length(same) == String.length(x) - 1, do: same
  end

  defp letter_frequency(string) when is_binary(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(%{}, fn letter, acc ->
      Map.put(acc, letter, Map.get(acc, letter, 0) + 1)
    end)
  end

  defp read_input do
    "../input" |> File.stream!() |> Enum.map(&String.trim/1)
  end
end

# DRIVER
IO.puts(DayTwo.partone())
IO.puts(DayTwo.parttwo())
