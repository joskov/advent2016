defmodule Task do
  def parse_line(line) do
    [a, b, c] = Regex.run(~r/([a-z-]+)-(\d+)\[([a-z]+)\]/, line, capture: :all_but_first)
    [String.replace(a, "-", ""), String.to_integer(b), c]
  end

  def count_chars(chars) do
    [first | _] = chars
    {-length(chars), first}
  end

  def get_char({_, char}), do: char

  def calculate_string(string) do
    string
      |> String.graphemes
      |> Enum.sort
      |> Enum.chunk_by(fn(x) -> x end)
      |> Enum.map(&count_chars/1)
      |> Enum.sort
      |> Enum.take(5)
      |> Enum.map(&get_char/1)
      |> Enum.join
  end

  def calculate_one([string, number, top]) do
    string = calculate_string(string)
    [string, number, top]
    if (string == top), do: number, else: 0
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> Enum.map(&calculate_one/1)
      |> Enum.sum
  end
end

{:ok, input} = File.read("input.txt")

# IO.puts input

result = Task.calculate(input)
IO.inspect result
