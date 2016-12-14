defmodule Task do
  @input 1352
  @target {31, 39}
  @start {1, 1, 0}

  def trace(current, log) do
    result = Enum.reduce(current, [], &(add_moves(&1, &2, log)))
    log = log ++ result
    trace(result, log)
  end

  def add_moves({_x, _y, false}, result, _log), do: result
  def add_moves({x, y, moves}, result, log) do
    result
      |> add_move({x + 1, y, moves + 1}, log)
      |> add_move({x - 1, y, moves + 1}, log)
      |> add_move({x, y + 1, moves + 1}, log)
      |> add_move({x, y - 1, moves + 1}, log)
  end

  def add_move(result, {x, _y, _moves}, _log) when x < 0, do: result
  def add_move(result, {_x, y, _moves}, _log) when y < 0, do: result
  def add_move(result, move, log) do
    test(move)
    found = Enum.any?(log ++ result, &(same_move?(move, &1)))
    if (found) do
      result
    else
      [check_field(move) | result]
    end
  end

  def test({x, y, move}) do
    if ({x, y} == @target) do
      IO.puts "Found the path in #{move} moves!"
      1 / 0
    end
  end

  def calculate() do
    trace([@start], [])
  end

  def same_move?({x, y, _}, {x, y, _}), do: true
  def same_move?(_, _), do: false

  def check_field({x, y, moves}) do
    value = (x * x) + 3 * x + (2 * x * y) + y + (y * y) + @input
    string = Integer.to_string(value, 2)
    chars = String.graphemes(string)
    count = Enum.count(chars, &(&1 == "1"))
    check = rem(count, 2) == 0
    moves = if (check), do: moves, else: false
    {x, y, moves}
  end
end

result = Task.calculate
IO.inspect result
