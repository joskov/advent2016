defmodule Task do
  def iterate(string, result) do
    matches = Regex.run(~r/(.*?)\((\d*)x(\d*)\)/, string)
    iterate_operation(matches, string, result)
  end

  def iterate_operation(nil, string, result), do: result + String.length(string)
  def iterate_operation([match, "", count, repeat], string, result) do
    string = String.replace_prefix(string, match, "")
    count = String.to_integer(count)
    repeat = String.to_integer(repeat)
    {compressed, string} = String.split_at(string, count)
    inner_result = iterate(compressed, 0) * repeat
    result = result + inner_result
    iterate(string, result)
  end
  def iterate_operation([match, left, count, repeat], string, result) do
    iterate_operation([match, "", count, repeat], string, result + String.length(left))
  end

  def calculate(input) do
    input
      |> String.trim
      |> iterate(0)
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.puts result
