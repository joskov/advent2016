defmodule Task do
  def parse_line(string) do
    string |> String.graphemes |> Enum.map(&to_int/1)
  end

  def trap_at(row, index) when index < 0, do: false
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
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> next_rows(limit)
      |> count_traps
  end

  def next_rows(rows, size) when length(rows) >= size, do: Enum.reverse(rows)
  def next_rows(rows, size) do
    [last_row | _] = rows
    new_row = for n <- 1..length(last_row), do: trap_check(last_row, n - 1)
    next_rows([new_row | rows], size)
  end

  def trap_check(row, index) do
    trap_check_tiles(traps_near(row, index))
  end

  def trap_check_tiles({true, true, false}), do: true
  def trap_check_tiles({false, true, true}), do: true
  def trap_check_tiles({true, false, false}), do: true
  def trap_check_tiles({false, false, true}), do: true
  def trap_check_tiles(_), do: false

  def count_traps(rows) do
    rows
      |> Enum.map(&count_traps_row/1)
      |> Enum.sum
  end

  def count_traps_row(row) do
    Enum.count(row, &(!&1))
  end
end

# input = ".^^.^.^^^^
# "
{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input, 40)
IO.inspect result
