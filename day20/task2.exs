defmodule Task do
  def parse_line(string) do
    [_, a, b] = Regex.run(~r/(\d+)-(\d+)/, string)
    {String.to_integer(a), String.to_integer(b)}
  end

  def run([], pointer, blocked, allowed, max) do
     allowed
  end
  def run([h | t], pointer, blocked, allowed, max) do
    inspect(h, pointer, blocked, allowed)
    {pointer, blocked, allowed} = check(h, pointer, blocked, allowed)
    run(t, pointer, blocked, allowed, max)
  end

  def inspect({min, max}, pointer, blocked, allowed) do
    IO.puts("Blocked: #{blocked}, Allowed: #{allowed}, Pointer: #{pointer}, Checking #{min} - #{max}")
  end

  def check({_min, max}, pointer, blocked, allowed) when max <= pointer, do: {pointer, blocked, allowed}
  def check({min, max}, pointer, blocked, allowed) do
    if (pointer > min) do
      {max + 1, blocked + (max - pointer + 1), allowed}
    else
      {max + 1, blocked + (max - min + 1), allowed + (min - pointer)}
    end
  end

  def calculate(input, max) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> Enum.sort
      |> List.insert_at(-1, {max, max})
      |> run(0, 0, 0, max)
  end
end

{:ok, input} = File.read("input.txt")
# IO.puts input
max = 4294967295

result = Task.calculate(input, max)
IO.inspect result
