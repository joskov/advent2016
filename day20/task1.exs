defmodule Task do
  def parse_line(string) do
    [_, a, b] = Regex.run(~r/(\d+)-(\d+)/, string)
    {String.to_integer(a), String.to_integer(b)}
  end

  def run([], _removed, result), do: result
  def run(_list, [], result), do: result
  def run(list, _removed, result) do
    IO.puts("Min is #{result}, list left #{length(list)}")
    {list, removed, result} = Enum.reduce(list, {[], [], result}, &check_row/2)
    run(list, removed, result)
  end

  def check_row({min, max} = current, {rest, removed, result}) do
    if (result >= min && result <= max) do
      {rest, [current | removed], max + 1}
    else
      {[current | rest], removed, result}
    end
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> run(false, 0)
  end
end

{:ok, input} = File.read("input.txt")
# IO.puts input

result = Task.calculate(input)
IO.inspect result
