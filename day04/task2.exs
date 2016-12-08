defmodule Task do
  def parse_line(line) do
    [a, b, c] = Regex.run(~r/([a-z-]+)-(\d+)\[([a-z]+)\]/, line, capture: :all_but_first)
    [a, String.to_integer(b), c]
  end

  def count_chars(chars) do
    [first | _] = chars
    count = if (first == "-"), do: 0, else: -length(chars)
    {count, first}
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

  def check_line([string, _number, top]) do
    calculate_string(string) == top
  end

  def decrypt(?-, _), do: ' '
  def decrypt(c, number) do
    window = ?z - ?a + 1
    start = c - ?a
    rem(start + number, window) + ?a
  end

  def decrypt([string, number, _top]) do
    string = string
      |> String.to_charlist
      |> Enum.map(fn(x) -> decrypt(x, number) end)
      |> List.to_string
    "#{string} - #{number}"
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> Enum.filter(&check_line/1)
      |> Enum.map(&decrypt/1)
      |> Enum.sort
      |> Enum.join("\n")
  end
end

{:ok, input} = File.read("input.txt")

# IO.puts input

result = Task.calculate(input)
IO.puts result
