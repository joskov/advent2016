defmodule Task do
  def parse_line(string) do
    string |> String.graphemes |> Enum.map(&to_int/1)
  end

  def trap_at(_row, index) when index < 0, do: false
  def trap_at(row, index) when index >= length(row), do: false
  def trap_at(row, index), do: Enum.at(row, index)

  def traps_near(row, index) do
    {trap_at(row, index - 1), trap_at(row, index), trap_at(row, index + 1)}
  end

  def to_int("."), do: false
  def to_int("^"), do: true

  def calculate(input, limit) do
    input
      |> String.split("\n")
      |> Enum.at(0)
      |> parse_line
      |> count_rows(limit)
  end

  def count_rows(row, size), do: count_rows(row, count_row(row), size - 1)
  def count_rows(_row, acc, 0), do: acc
  def count_rows(row, acc, left) do
    new_row = for n <- 1..length(row), do: trap_check(row, n - 1)
    acc = acc + count_row(new_row)
    count_rows(new_row, acc, left - 1)
  end

  def trap_check(row, index) do
    trap_check_tiles(traps_near(row, index))
  end

  def trap_check_tiles({true, true, false}), do: true
  def trap_check_tiles({false, true, true}), do: true
  def trap_check_tiles({true, false, false}), do: true
  def trap_check_tiles({false, false, true}), do: true
  def trap_check_tiles(_), do: false

  def count_row(row) do
    Enum.count(row, &(!&1))
  end
end

# input = ".^^.^.^^^^
# "
{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input, 400_000)
IO.inspect result
