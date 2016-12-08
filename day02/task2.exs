defmodule Task do
  # Keypad
  # ..1..
  # .234.
  # 56789
  # .ABC.
  # ..D..
  #
  # Positions
  # 1 = [x: 0, y: -2]
  # 2 = [x: -1, y: -1]
  # 3 = [x: 0, y: -1]
  # 4 = [x: 1, y: -1]
  # 5 = [x: -2, y: 0]
  # 6 = [x: -1, y: 0]
  # 7 = [x: 0, y: 0]
  # 8 = [x: 1, y: 0]
  # 9 = [x: 2, y: 0]
  # A = [x: -1, y: 1]
  # B = [x: 0, y: 1]
  # C = [x: 1, y: 1]
  # D = [x: 0, y: 2]
  def num([x: 0, y: -2]), do: "1"
  def num([x: -1, y: -1]), do: "2"
  def num([x: 0, y: -1]), do: "3"
  def num([x: 1, y: -1]), do: "4"
  def num([x: -2, y: 0]), do: "5"
  def num([x: -1, y: 0]), do: "6"
  def num([x: 0, y: 0]), do: "7"
  def num([x: 1, y: 0]), do: "8"
  def num([x: 2, y: 0]), do: "9"
  def num([x: -1, y: 1]), do: "A"
  def num([x: 0, y: 1]), do: "B"
  def num([x: 1, y: 1]), do: "C"
  def num([x: 0, y: 2]), do: "D"

  def move("L", [x: x, y: y]) when x - abs(y) > -2, do: [x: x - 1, y: y]
  def move("R", [x: x, y: y]) when x + abs(y) < 2, do: [x: x + 1, y: y]
  def move("U", [x: x, y: y]) when y - abs(x) > -2, do: [x: x, y: y - 1]
  def move("D", [x: x, y: y]) when y + abs(x) < 2, do: [x: x, y: y + 1]
  def move(_move, pos), do: pos

  def moves(input) do
    lines = String.split(input, "\n")
    lines = List.delete_at(lines, -1)
    Enum.map(lines, &String.graphemes/1)
  end

  def calculate(input) do
    moves = moves(input)
    positions = iterate(moves, [x: -2, y: 0], [])
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
