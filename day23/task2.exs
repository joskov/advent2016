defmodule Task do
  def parse_line(line) do
    line
      |> String.split(" ")
      |> Enum.map(&parse_elem/1)
  end

  def parse_elem(value), do: parse_elem(value, Integer.parse(value))
  def parse_elem(value, :error), do: String.to_atom(value)
  def parse_elem(_value, {int, ""}), do: int

  def loop(list), do: loop(list, 0, init)
  def loop(list, pointer, info) when pointer >= length(list), do: info
  def loop(list, pointer, info) do
    item = Enum.at(list, pointer)
    {list, pointer, info} = execute(item, list, pointer, info)
    loop(list, pointer, info)
  end

  def execute([:cpy, _value, elem], list, pointer, info) when is_integer(elem) do
    IO.puts("WTF")
    1 / 0
    {list, pointer + 1, info}
  end
  def execute([:cpy, value, elem], list, pointer, info) do
    value = parse_value(info, value)
    info = set(info, elem, value)
    {list, pointer + 1, info}
  end
  def execute([:inc, value1, value2, elem], list, pointer, info) do
    value1 = parse_value(info, value1)
    value2 = parse_value(info, value2)
    info = set(info, elem, get(info, elem) + value1 * value2)
    {list, pointer + 1, info}
  end
  def execute([:inc, elem], list, pointer, info) do
    info = set(info, elem, get(info, elem) + 1)
    {list, pointer + 1, info}
  end
  def execute([:dec, elem], list, pointer, info) do
    info = set(info, elem, get(info, elem) - 1)
    {list, pointer + 1, info}
  end
  def execute([:jnz, value, change], list, pointer, info) do
    value = parse_value(info, value)
    change = parse_value(info, change)
    pointer = if (value == 0), do: pointer + 1, else: pointer + change
    {list, pointer, info}
  end
  def execute([:tgl, elem], list, pointer, info) do
    toggle_index = get(info, elem) + pointer
    item = Enum.at(list, toggle_index)
    list = toggle_elem(list, toggle_index, item)
    {list, pointer + 1, info}
  end

  def toggle_elem(list, _, nil), do: list
  def toggle_elem(list, index, item) do
    item = toggle_instruction(item)
    List.replace_at(list, index, item)
  end

  def toggle_instruction([:inc, elem]), do: [:dec, elem]
  def toggle_instruction([_, elem]), do: [:inc, elem]
  def toggle_instruction([:jnz, a, b]), do: [:cpy, a, b]
  def toggle_instruction([_, a, b]), do: [:jnz, a, b]

  def get(info, elem), do: Keyword.get(info, elem)
  def set(info, elem, value) do
    result = Keyword.put(info, elem, value)
    # IO.inspect(result)
    result
  end

  def parse_value(_info, value) when is_integer(value), do: value
  def parse_value(info, value), do: get(info, value)

  def init do
    [a: 12, b: 0, c: 0, d: 0]
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> loop
  end
end

input = "cpy 2 a
tgl a
tgl a
tgl a
cpy 1 a
dec a
dec a
"
{:ok, input} = File.read("input2.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
