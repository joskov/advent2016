defmodule Task do
  def parse_line(line) do
    String.split(line, " ")
  end

  def loop(list), do: loop(list, 0, init)
  def loop(list, pointer, info) when pointer >= length(list), do: info
  def loop(list, pointer, info) do
    {info, pointer} = execute(Enum.at(list, pointer), pointer, info)
    loop(list, pointer, info)
  end

  def execute(["cpy", value, elem], pointer, info) do
    value = parse_value(info, value)
    info = set(info, elem, value)
    {info, pointer + 1}
  end
  def execute(["inc", elem], pointer, info) do
    info = set(info, elem, get(info, elem) + 1)
    {info, pointer + 1}
  end
  def execute(["dec", elem], pointer, info) do
    info = set(info, elem, get(info, elem) - 1)
    {info, pointer + 1}
  end
  def execute(["jnz", elem, change], pointer, info) do
    change = String.to_integer(change)
    value = get(info, elem)
    pointer = if (value == 0), do: pointer + 1, else: pointer + change
    {info, pointer}
  end

  def get(info, elem), do: Keyword.get(info, String.to_atom(elem))
  def set(info, elem, value), do: Keyword.put(info, String.to_atom(elem), value)

  def parse_value(info, value) do
    parse_value(info, Integer.parse(value), value)
  end
  def parse_value(info, {integer, _}, _), do: integer
  def parse_value(info, :error, value), do: get(info, value)

  def init do
    for c <- ?a..?d, do: {List.to_atom([c]), 0}
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> loop
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
