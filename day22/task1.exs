defmodule Task do
  def parse_line(string) do
    [node, size, used, avail, usage] = Regex.split(~r/\s+/, string)
    {size, "T"} = Integer.parse(size)
    {used, "T"} = Integer.parse(used)
    {avail, "T"} = Integer.parse(avail)
    {usage, "%"} = Integer.parse(usage)
    {node, size, used, avail, usage / 100}
  end

  def cleanup(list) do
    list
      |> tl
      |> tl
      |> List.delete_at(-1)
  end

  def viable_pairs(list), do: viable_pairs(list, 0)
  def viable_pairs([], count), do: count
  def viable_pairs([h | t], count) do
    added = check_pairs(h, t)
    viable_pairs(t, count + added)
  end

  def check_pairs(node, list) do
    {count, _} = Enum.reduce(list, {0, node}, &add_pair/2)
    count
  end

  def add_pair(check_node, {count, node}) do
    count = if (viable_pair?(node, check_node)), do: count + 1, else: count
    count = if (viable_pair?(check_node, node)), do: count + 1, else: count
    {count, node}
  end

  def viable_pair?({_, _, used, _, _}, {_, _, _, avail, _}) do
    used > 0 && avail >= used
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> cleanup
      |> Enum.map(&parse_line/1)
      |> viable_pairs
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
