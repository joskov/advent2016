defmodule Task do
  def parse_line(string) do
    result = Regex.run(~r/Disc #(\d+) has (\d+) positions; at time=(\d+), it is at position (\d+)./, string)
    [_ | result] = result
    result = Enum.map(result, &String.to_integer/1)
    [_n, size, time, position] = result
    {size, time, position}
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> add_custom
      |> iterate
  end

  def add_custom(list), do: list ++ [{11, 0, 0}]

  def iterate(list), do: iterate(list, 0, false)
  def iterate(_list, index, true) do
    IO.puts "Passed at index #{index - 1}"
    true
  end
  def iterate(list, index, false) do
    passed = check_iteration(list, index, 1, true)
    iterate(list, index + 1, passed)
  end

  def check_iteration(_, index, offset, false) do
    IO.puts "Iteration #{index} failed at disc #{offset - 1}"
    false
  end
  def check_iteration([], index, _offset, true), do: true
  def check_iteration([h | t], index, offset, true) do
    passed = check_disc(h, index + offset)
    check_iteration(t, index, offset + 1, passed)
  end

  def check_disc({size, time, position}, index) do
    rem((index - time + size + position), size) == 0
  end
end

input = "Disc #1 has 5 positions; at time=0, it is at position 4.
Disc #2 has 2 positions; at time=0, it is at position 1.
"
{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
