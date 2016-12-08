defmodule Task do
  def possible([a, b, c]) when a + b <= c, do: 0
  def possible([a, b, c]) when b + c <= a, do: 0
  def possible([a, b, c]) when c + a <= b, do: 0
  def possible([_a, _b, _c]), do: 1

  def parse_line(line) do
    numbers = String.split(line)
    Enum.map(numbers, &String.to_integer/1)
  end

  def transpose([[]|_]), do: []
  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

  def flatten([]), do: []
  def flatten([head | tail]), do: head ++ flatten(tail)

  def calculate(input) do
    lines = String.split(input, "\n")
    lines = Enum.map(lines, &parse_line/1)
    lines = Enum.chunk(lines, 3)
    lines = Enum.map(lines, &transpose/1)
    lines = flatten(lines)
    lines = Enum.map(lines, &possible/1)
    Enum.sum(lines)
  end
end

{:ok, input} = File.read("input2.txt")

IO.puts input

result = Task.calculate(input)
IO.inspect result
