defmodule Task do
  def parse_line(line) do
    line
      |> String.split(" ")
      |> Enum.map(&parse_elem/1)
  end

  def parse_elem(value), do: parse_elem(value, Integer.parse(value))
  def parse_elem(value, :error), do: String.to_atom(value)
  def parse_elem(_value, {int, ""}), do: int

  def loop(list), do: loop(list, 0, false)
  def loop(list, index, false) do
    result = loop_internal(list, 0, init(index))
    loop(list, index + 1, result)
  end

  def loop_internal(list, pointer, false) do
    false
  end

  def loop_internal(list, pointer, info) when pointer >= length(list), do: info
  def loop_internal(list, pointer, info) do
    item = Enum.at(list, pointer)
    {list, pointer, info} = execute(item, list, pointer, info)
    loop_internal(list, pointer, info)
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
  def execute([:out, value], list, pointer, info) do
    value = parse_value(info, value)
    info = add(info, :o, value)
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
    result = Enum.sort(result)
    result
  end
  def add(info, elem, value) do
    old = get(info, elem)
    add_internal(info, elem, old, value)
  end
  def add_internal(_info, _elem, [value | _t], value), do: false
  def add_internal(info, elem, old, value) do
    result = set(info, elem, [value | old])
    IO.inspect(result)
    result
  end

  def parse_value(_info, value) when is_integer(value), do: value
  def parse_value(info, value), do: get(info, value)

  def init(start) do
    [a: start, b: 0, c: 0, d: 0, o: [], i: start]
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
