defmodule Task do
  def reduce_lines(line, {y, walls, points}) do
    chars = String.graphemes(line)
    {_, walls, points} = Enum.reduce(chars, {0, walls, points}, &(reduce_chars(&1, &2, y)))
    {y + 1, walls, points}
  end

  def reduce_chars(".", {x, walls, points}, _y), do: {x + 1, walls, points}
  def reduce_chars("#", {x, walls, points}, y), do: {x + 1, [{x, y} | walls], points}
  def reduce_chars(c, {x, walls, points}, y), do: {x + 1, walls, [{String.to_integer(c), x, y} | points]}

  def trace(walls, {point1, x1, y1}, {point2, x2, y2}) do
    moves = trace(walls, [{x1, y1}], {x2, y2}, [], 0, false)
    IO.puts("From #{point1} to #{point2} is #{moves} moves")
    {point1, point2, moves}
  end
  def trace(_walls, _current, _target, _log, moves, true), do: moves
  def trace(_walls, [], _target, _log, _moves, false) do
    IO.puts("No path available!")
    false
  end
  def trace(walls, current, target, log, moves, false) do
    current = Enum.reduce(current, [], &(add_moves(&1, &2, walls, target, log)))
    found = Enum.member?(current, target)
    log = log ++ current
    trace(walls, current, target, log, moves + 1, found)
  end

  def add_moves({x, y}, result, walls, target, log) do
    result
      |> add_move({x + 1, y}, walls, target, log)
      |> add_move({x - 1, y}, walls, target, log)
      |> add_move({x, y + 1}, walls, target, log)
      |> add_move({x, y - 1}, walls, target, log)
  end

  def add_move(result, move, walls, target, log) do
    duplicate = Enum.member?(log ++ result, move)
    blocked = Enum.member?(walls, move)
    add_possible_move(result, move, duplicate, blocked)
  end

  def add_possible_move(result, move, false, false), do: [move | result]
  def add_possible_move(result, _move, _duplicate, _blocked), do: result

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.reduce({0, [], []}, &reduce_lines/2)
      |> fix
      |> find_paths
      |> Enum.min
  end

  def find_paths(info), do: find_paths(info, [])
  def find_paths({walls, points}, []) do
    possible = combinations(points, [])
    distances = Enum.map(possible, fn {a, b} -> trace(walls, a, b) end )
    [first_point | other_points] = Enum.map(points, fn {point, _x, _y} -> point end)
    path_combinations = path_combinations(other_points, [first_point], [])
    Enum.map(path_combinations, &(calculate_path_length(&1, distances, 0)))
  end

  def calculate_path_length([_last], _distances, length), do: length
  def calculate_path_length([first | rest], distances, length) do
    second = hd(rest)
    length = length + find_distance(first, second, distances)
    calculate_path_length(rest, distances, length)
  end

  def find_distance(first, second, distances) do
    result = Enum.find(distances, &(same?(&1, first, second)))
    {_x, _y, distance} = result
    distance
  end

  def same?({first, second, _length}, first, second), do: true
  def same?({second, first, _length}, first, second), do: true
  def same?(_check, _first, _second), do: false

  def path_combinations([], current, result), do: [Enum.reverse(current) | result]
  def path_combinations(add, current, result) do
    Enum.reduce(add, result, &(path_combinations(List.delete(add, &1), [&1 | current], &2)))
  end

  def combinations([_last], result), do: Enum.sort(result)
  def combinations([h | t], result) do
    result = combine_with(t, h, result)
    combinations(t, result)
  end

  def combine_with([], _point, result), do: result
  def combine_with([h | t], point, result) do
    combine_with(t, point, [{point, h} | result])
  end

  def fix({_, walls, points}), do: {Enum.sort(walls), Enum.sort(points)}
end

input = "###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"
{:ok, input} = File.read("input.txt")
result = Task.calculate(input)
IO.inspect result
