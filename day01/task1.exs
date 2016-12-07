defmodule Task do
  def instructions(input) do
    Regex.scan(~r/([LR])(\d+)/, input, capture: :all_but_first)
  end

  def print_matches([head | tail]) do
    [rotation, distance] = head
    IO.puts "#{rotation} #{distance}"
    print_matches(tail)
  end

  def print_matches([]) do
  end

  def iterate([head | tail], position, direction) do
    [rotation, distance] = head
    {distance, _} = Integer.parse(distance)
    direction = rotate(direction, rotation)
    position = move(position, movement(direction, distance))
    iterate(tail, position, direction)
  end

  def iterate([], position, _direction) do
    position
  end

  # Rotate [x: dX, y: dY]
  def rotate([x: 0, y: 1], "R"), do: [x: -1, y: 0]
  def rotate([x: -1, y: 0], "R"), do: [x: 0, y: -1]
  def rotate([x: 0, y: -1], "R"), do: [x: 1, y: 0]
  def rotate([x: 1, y: 0], "R"), do: [x: 0, y: 1]
  def rotate([x: 0, y: 1], "L"), do: [x: 1, y: 0]
  def rotate([x: 1, y: 0], "L"), do: [x: 0, y: -1]
  def rotate([x: -1, y: 0], "L"), do: [x: 0, y: 1]
  def rotate([x: 0, y: -1], "L"), do: [x: -1, y: 0]

  def movement([x: x, y: y], distance), do: [x: x * distance, y: y * distance]
  def move([x: x, y: y], [x: dx, y: dy]), do: [x: x + dx, y: y + dy]
end

{:ok, input} = File.read("input.txt")

IO.puts input
result = input |> Task.instructions |> Task.iterate([x: 0, y: 0], [x: 0, y: -1])
IO.puts "X: #{result[:x]}, Y: #{result[:y]}, Travel: #{abs(result[:x]) + abs(result[:y])}"
