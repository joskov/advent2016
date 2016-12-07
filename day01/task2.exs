defmodule Task do
  def instructions(input) do
    Regex.scan(~r/([LR])(\d+)/, input, capture: :all_but_first)
  end

  def iterate([head | tail], position, direction, moves, []) do
    [rotation, distance] = head
    {distance, _} = Integer.parse(distance)
    direction = rotate(direction, rotation)
    {position, moves, found} = move(position, direction, distance, moves, [])
    iterate(tail, position, direction, moves, found)
  end

  def iterate(_list, _position, _direction, _moves, found) do
    found
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

  def move([x: x, y: y] = position, [x: dx, y: dy], distance, moves, []) do
    new_position = [x: x + dx * distance, y: y + dy * distance]
    move = {position, new_position}
    IO.puts "Move #{inspect(move)}"
    found = detect_repeat_positions(moves, move, [])
    {new_position, [move | moves], found}
  end

  def detect_repeat_positions([head | tail], {position, _new_position} = move, found) do
    crossing = cross(head, move)
    if (crossing && crossing != position) do
      IO.puts "Crossing #{inspect(crossing)}"
      found = [crossing | found]
    end
    detect_repeat_positions(tail, move, found)
  end
  def detect_repeat_positions([], _move, found), do: found

  def cross({[x: x11, y: y], [x: x12, y: y]}, {[x: x, y: y21], [x: x, y: y22]}) do
    cross_check([x: x, y: y], [x1: x11, x2: x12, y1: y21, y2: y22])
  end
  def cross({[x: x, y: y11], [x: x, y: y12]}, {[x: x21, y: y], [x: x22, y: y]}) do
    cross_check([x: x, y: y], [x1: x21, x2: x22, y1: y11, y2: y12])
  end
  def cross(_move1, _move2), do: false

  def cross_check([x: x, y: y] = return, [x1: x1, x2: x2, y1: y1, y2: y2]) do
    x_check = (x >= x1 && x <= x2) || (x <= x1 && x >= x2)
    y_check = (y >= y1 && y <= y2) || (y <= y1 && y >= y2)
    if (x_check && y_check), do: return, else: false
  end
end

{:ok, input} = File.read("input.txt")

IO.puts input
result = input |> Task.instructions |> Task.iterate([x: 0, y: 0], [x: 0, y: -1], [], [])
IO.puts inspect(result)
[first | _] = result
IO.puts "X: #{first[:x]}, Y: #{first[:y]}, Travel: #{abs(first[:x]) + abs(first[:y])}"
