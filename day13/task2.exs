defmodule Task do
  @input 1352
  @start {1, 1, 0}

  def trace(current, log, 50) do
    log = current ++ log
    Enum.count(log, &open_space?/1)
  end
  def trace(current, log, move) do
    log = current ++ log
    result = Enum.reduce(current, [], &(add_moves(&1, &2, log, move)))
    trace(result, log, move + 1)
  end

  def open_space?({_x, _y, false}), do: false
  def open_space?(_), do: true

  def add_moves({_x, _y, false}, result, _log, _moves), do: result
  def add_moves({x, y, _old}, result, log, moves) do
    result
      |> add_move({x + 1, y, moves}, log)
      |> add_move({x - 1, y, moves}, log)
      |> add_move({x, y + 1, moves}, log)
      |> add_move({x, y - 1, moves}, log)
  end

  def add_move(result, {x, _y, _moves}, _log) when x < 0, do: result
  def add_move(result, {_x, y, _moves}, _log) when y < 0, do: result
  def add_move(result, move, log) do
    found = Enum.any?(log ++ result, &(same_move?(move, &1)))
    if (found) do
      result
    else
      [check_field(move) | result]
    end
  end

  def calculate() do
    trace([@start], [], 0)
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
