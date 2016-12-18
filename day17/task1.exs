defmodule Task do
  @input "qljzarfv"

  def calculate do
    calculate([{@input, 0, 0}], 0)
  end
  def calculate([], index) do
    IO.puts "Dead end on index #{index}"
  end
  def calculate(list, index) do
    IO.puts "Working on index #{index}"
    list = Enum.reduce(list, [], &add_possible/2)
    calculate(list, index + 1)
  end

  def add_possible(old, acc) do
    possible(old) ++ acc
  end

  def possible({input, 3, 3}) do
    IO.puts(input)
    1 / 0
  end
  def possible({input, _x, _y} = old) do
    hash = :crypto.hash(:md5, input) |> Base.encode16(case: :lower) |> String.graphemes
    all_moves
      |> Enum.filter(&(check_move(hash, &1)))
      |> Enum.map(&(complete_move(old, &1)))
      |> Enum.filter(&allowed_move?/1)
  end

  def complete_move({input, x, y}, {c, _i, dx, dy}) do
    {input <> c, x + dx, y + dy}
  end

  def all_moves do
    [{"U", 0, 0, -1}, {"D", 1, 0, 1}, {"L", 2, -1, 0}, {"R", 3, 1, 0}]
  end

  def check_move(hash, {_c, i, _dx, _dy}) do
    Enum.at(hash, i) |> open?
  end

  def allowed_move?({_i, x, _y}) when x < 0, do: false
  def allowed_move?({_i, x, _y}) when x > 3, do: false
  def allowed_move?({_i, _x, y}) when y < 0, do: false
  def allowed_move?({_i, _x, y}) when y > 3, do: false
  def allowed_move?(_), do: true

  def open?("b"), do: true
  def open?("c"), do: true
  def open?("d"), do: true
  def open?("e"), do: true
  def open?("f"), do: true
  def open?(_), do: false
end

result = Task.calculate
IO.inspect result
