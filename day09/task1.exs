defmodule Task do
  def iterate(string, result) do
    matches = Regex.run(~r/(.*?)\((\d*)x(\d*)\)/, string)
    iterate_operation(matches, string, result)
  end

  def iterate_operation(nil, string, result), do: result <> string
  def iterate_operation([match, "", count, repeat], string, result) do
    string = String.replace_prefix(string, match, "")
    {compressed, string} = String.split_at(string, String.to_integer(count))
    uncompressed = String.duplicate(compressed, String.to_integer(repeat))
    result = result <> uncompressed
    iterate(string, result)
  end
  def iterate_operation([match, left, count, repeat], string, result) do
    iterate_operation([match, "", count, repeat], string, result <> left)
  end

  def calculate(input) do
    input
      |> String.trim
      |> iterate("")
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
# IO.inspect result
IO.puts String.length(result)
