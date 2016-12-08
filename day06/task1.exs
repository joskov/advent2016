defmodule Task do
  def transpose([[]|_]), do: []
  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

  def get_length([h | _t] = list) do
    {length(list), h}
  end

  def get_char({_count, char}), do: char

  def most_used(list) do
    list
      |> Enum.sort
      |> Enum.chunk_by(&(&1))
      |> Enum.map(&get_length/1)
      |> Enum.sort
      |> Enum.at(-1)
      |> get_char
  end

  def calculate(input) do
    lines = input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&String.graphemes/1)
      |> transpose
      |> Enum.map(&most_used/1)
      |> Enum.join
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
