defmodule Task do
  @input "10010000000110000"
  @limit 272

  def input do
    @input
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
  end

  def calculate do
    input
      |> generate(@limit)
      |> checksum
  end

  def checksum(input) when rem(length(input), 2) == 1 do
    IO.puts "YAY, #{Enum.join(input)}!"
  end
  def checksum(input) do
    input
      |> Enum.chunk(2)
      |> Enum.map(&chesum_pair/1)
      |> checksum
  end

  def chesum_pair([a, b]) when a == b, do: 1
  def chesum_pair([_a, _b]), do: 0

  def generate(input, limit) when length(input) >= limit do
    Enum.slice(input, 0, limit)
  end
  def generate(input, limit) do
    input = input ++ [0] ++ reverse(input)
    generate(input, limit)
  end

  def reverse(input) do
    input
      |> Enum.reverse
      |> Enum.map(&toggle/1)
  end

  def toggle(1), do: 0
  def toggle(0), do: 1
end

result = Task.calculate
IO.inspect result
