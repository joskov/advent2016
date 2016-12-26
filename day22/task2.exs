# ExUnit.start

defmodule Node do
  defstruct x: nil, y: nil, size: nil, used: nil, important: false
  defimpl String.Chars, for: Node do
    def to_string(node), do: "#{node.x}:#{node.y}, size: #{node.size} used: #{node.used}"
  end
end

defmodule Task2 do
  # use ExUnit.Case

  def parse_line(string) do
    [node, size, used, _free, _usage] = Regex.split(~r/\s+/, string)
    [_, x, y] = Regex.run(~r/x(\d+)-y(\d+)/, node)
    x = String.to_integer(x)
    y = String.to_integer(y)
    {size, "T"} = Integer.parse(size)
    {used, "T"} = Integer.parse(used)
    # {free, "T"} = Integer.parse(free)
    %Node{x: x, y: y, size: size, used: used}
  end

  def mark_important(nodes) do
    old = node_at(nodes, nodes |> starting)
    replace(nodes, old, %{old | important: true})
  end

  def run_first(nodes), do: run_first([{nodes, free(nodes), []}], free_destination(nodes), [free(nodes)], nil)
  def run_first([], _target, _covered, _found) do
    IO.puts("Got stuck!")
  end
  def run_first(current, target, covered, nil) do
    {current, covered} = Enum.reduce(current, {[], covered}, &next_steps/2)
    found = Enum.find(current, &(check?(&1, target)))
    run_first(current, target, covered, found)
  end
  def run_first(_current, _target, _covered, {nodes, coords, path}) do
    {nodes, coords, path}
  end

  def run_bridge(current) do
    force_move({1, 0}, current)
  end

  def run_second(current), do: run_second(current, false)
  def run_second(current, true), do: current
  def run_second(current, false) do
    current = Enum.reduce(rotate_moves, current, &force_move/2)
    {nodes, _coords, _log} = current
    found = node_at(nodes, {0, 0}).important
    run_second(current, found)
  end

  def force_move({dx, dy}, {nodes, {x, y} = old_coords, log}) do
    old = node_at(nodes, old_coords)
    new_coords = {x + dx, y + dy}
    new = node_at(nodes, new_coords)
    moved = move(nodes, old, new)
    {moved, new_coords, [new_coords | log]}
  end

  def rotate_moves, do: [{0, 1}, {-1, 0}, {-1, 0}, {0, -1}, {1, 0}]

  def check?({_nodes, {x, y}, _log}, {x, y}), do: true
  def check?(_, _), do: false

  def next_steps(from, acc) do
    Enum.reduce(directions, acc, &(add_step(from, &1, &2)))
  end

  def add_step({nodes, {x, y} = old_coords, log}, {dx, dy}, {result, covered}) do
    old = node_at(nodes, old_coords)
    new_coords = {x + dx, y + dy}
    new = node_at(nodes, new_coords)
    not_covered = !Enum.member?(covered, new_coords)
    check = can_move?(old, new)
    if (check && not_covered) do
      moved = move(nodes, old, new)
      {[{moved, new_coords, [new_coords | log]} | result], [new_coords | covered]}
    else
      {result, covered}
    end
  end

  def can_move?(_old, nil), do: false
  def can_move?(old, new), do: (old.size - old.used) >= new.used

  def move(nodes, old, new) do
    if (old == nil || new == nil || (old.size < old.used + new.used)), do: throw("Cannot Move!")
    nodes = replace(nodes, old, %{old | used: old.used + new.used, important: new.important})
    nodes = replace(nodes, new, %{new | used: 0, important: false})
    nodes
  end

  def directions, do: [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def node_at(nodes, {x, y}) do
    Enum.find(nodes, &(&1.x == x && &1.y == y))
  end

  def index_of(nodes, search) do
    Enum.find_index(nodes, &(&1 == search))
  end

  def replace(nodes, old, new) do
    index = index_of(nodes, old)
    List.replace_at(nodes, index, new)
  end

  def starting(nodes) do
    max_x = Enum.reduce(nodes, 0, &(if (&1.x > &2), do: &1.x, else: &2))
    {max_x, 0}
  end
  def ending(_nodes), do: {0, 0}
  def free(nodes) do
    top = nodes |> Enum.sort_by(&(&1.size - &1.used), &>=/2) |> hd
    {top.x, top.y}
  end
  def free_destination(nodes) do
    {x, y} = starting(nodes)
    {x - 1, y}
  end

  def calculate do
    parsed_input
      |> mark_important
      |> run_first
      |> run_bridge
      |> run_second
      |> count_log
  end

  def count_log({_nodes, _current, log}), do: length(log)

  def input do
    {:ok, result} = File.read("input.txt")
    result
  end

  def parsed_input do
    input
      |> String.split("\n")
      |> Enum.drop(2)
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
  end

  # @tag :skip
  # test "node" do
  #   node = parse_line("/dev/grid/node-x1-y5     87T   66T    21T   75%")
  #   assert node.x == 1
  #   assert node.y == 5
  #   assert node.size == 87
  #   assert node.used == 66
  # end
  #
  # @tag :skip
  # test "points" do
  #   assert ending(parsed_input) == {0, 0}
  #   assert starting(parsed_input) == {33, 0}
  #   assert free(parsed_input) == {20, 25}
  #   assert free_destination(parsed_input) == {32, 0}
  # end
  #
  # @tag :skip
  # test "move free" do
  #   {_nodes, current, path} = parsed_input |> run_first
  #   assert length(path) == 69
  #   assert current == {32, 0}
  # end
  #
  # @tag :skip
  # test "move second" do
  #   result = calculate
  #   assert result == 230
  # end
end

result = Task2.calculate
IO.puts("Result is #{result}")
