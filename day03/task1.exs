defmodule Task do
  def possible([a, b, c]) when a + b <= c, do: 0
  def possible([a, b, c]) when b + c <= a, do: 0
  def possible([a, b, c]) when c + a <= b, do: 0
  def possible([_a, _b, _c]), do: 1

  def parse_line(line) do
    numbers = String.split(line)
    Enum.map(numbers, &String.to_integer/1)
  end

  def calculate(input) do
    lines = String.split(input, "\n")
    lines = List.delete_at(lines, -1)
    lines = Enum.map(lines, &parse_line/1)
    lines = Enum.map(lines, &possible/1)
    Enum.sum(lines)
  end
end

{:ok, input} = File.read("input.txt")

IO.puts input

result = Task.calculate(input)
IO.inspect result
