"../input"
|> File.stream!()
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)
|> Enum.sum()
|> IO.puts()
