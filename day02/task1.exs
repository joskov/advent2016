defmodule Task do
  def pos(n), do: [x: rem(n - 1, 3), y: div(n - 1, 3)]
  def num([x: x, y: y]), do: y * 3 + x + 1

  def move("L", [x: x, y: y]) when x > 0, do: [x: x - 1, y: y]
  def move("R", [x: x, y: y]) when x < 2, do: [x: x + 1, y: y]
  def move("U", [x: x, y: y]) when y > 0, do: [x: x, y: y - 1]
  def move("D", [x: x, y: y]) when y < 2, do: [x: x, y: y + 1]
  def move(_move, pos), do: pos

  def moves(input) do
    lines = String.split(input, "\n")
    lines = List.delete_at(lines, -1)
    Enum.map(lines, &String.graphemes/1)
  end

  def calculate(input) do
    moves = moves(input)
    positions = iterate(moves, [x: 1, y: 1], [])
    numbers = Enum.map(positions, &num/1)
    Enum.join(numbers, "")
  end

  def iterate([moves | tail], position, result) do
    position = Enum.reduce(moves, position, &move/2)
    result = [position | result]
    iterate(tail, position, result)
  end

  def iterate([], _current, result), do: Enum.reverse(result)
end

{:ok, input} = File.read("input.txt")

IO.puts input

result = Task.calculate(input)
IO.puts result
