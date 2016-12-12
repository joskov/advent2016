defmodule Parse do
  def parse(list), do: parse(list, {[], [], []}, 3)
  def parse([], result, _floor), do: {3, strip(result)}
  def parse([h | t], result, floor) do
    parse(t, parse_line(h, result, floor), floor - 1)
  end

  def parse_line(string, result, floor) do
    generators =
      Regex.scan(~r/(\w+)\sgenerator/, string, capture: :all_but_first)
      |> Enum.map(&hd/1)
    microchips =
      Regex.scan(~r/(\w+)-compatible\smicrochip/, string, capture: :all_but_first)
      |> Enum.map(&hd/1)

    result = Enum.reduce(generators, result, &(add_generator(&1, floor, &2)))
    result = Enum.reduce(microchips, result, &(add_chip(&1, floor, &2)))
    result
  end

  def add_chip(c, c_floor, {generators, chips, pairs}) do
    found = find_element(generators, c)
    if (found) do
      {_name, g_floor} = found
      {generators -- [found], chips, [{c, c_floor, g_floor} | pairs]}
    else
      {generators, [{c, c_floor} | chips], pairs}
    end
  end

  def add_generator(g, g_floor, {generators, chips, pairs}) do
    found = find_element(chips, g)
    if (found) do
      {_name, c_floor} = found
      {generators, chips -- [found], [{g, c_floor, g_floor} | pairs]}
    else
      {[{g, g_floor} | generators], chips, pairs}
    end
  end

  def find_element([], name), do: false
  def find_element([{name, _floor} = result | _tail], name), do: result
  def find_element([_ | tail], name), do: find_element(tail, name)

  def strip({[], [], pairs}) do
    strip_names(pairs)
  end

  def strip_names(list) do
    list
      |> Enum.map(&(Tuple.delete_at(&1, 0)))
      |> Enum.sort
  end
end

defmodule Task do
  def brute_force(current), do: brute_force([current], [], [], 0)
  def brute_force([], _backlog, [], step) do
    IO.puts "Stuck on step #{step}"
  end
  def brute_force([], backlog, log, step) do
    IO.puts "Working on step #{step} possible moves #{length(log)}"
    brute_force(log, backlog, [], step + 1)
  end
  def brute_force([h | t], backlog, log, step) do
    result = brute_force_inner(h, backlog, step)
    log = log ++ result
    backlog = backlog ++ result
    brute_force(t, backlog, log, step)
  end

  def brute_force_inner({elevator, data}, backlog, step) do
    # IO.puts("------")
    # IO.inspect {elevator, data}
    # IO.puts("------")

    if (final(data)) do
      IO.puts "We made it in #{step} steps!"
      raise "YAY"
    end
    possible_moves = for i <- 0..length(data), do: possible_move(Enum.at(data, i), elevator, i)
    possible_moves = List.flatten(possible_moves)

    moves = for a <- possible_moves, b <- possible_moves, a > b, do: [a, b]
    moves = for a <- possible_moves, do: [a], into: moves

    result = []
    result = apply_moves(moves, data, elevator + 1, result)
    result = apply_moves(moves, data, elevator - 1, result)
    result = Enum.filter(result, &possible_data/1)
    result = Enum.uniq(result)
    result = result -- backlog

    # IO.puts("------")
    # IO.inspect(backlog)
    # IO.puts("------")

    result
  end

  def final(data) do
    Enum.all?(data, &(&1 == {0, 0}))
  end

  def possible_move({elevator, elevator}, elevator, i), do: [{i, 0}, {i, 1}]
  def possible_move({elevator, _generator}, elevator, i), do: [{i, 0}]
  def possible_move({_chip, elevator}, elevator, i), do: [{i, 1}]
  def possible_move(_item, _elevator, _i), do: []

  def apply_moves([], _, _, result), do: result
  def apply_moves(_, _, new, result) when new > 3, do: result
  def apply_moves(_, _, new, result) when new < 0, do: result
  def apply_moves([move | t], data, new, result) do
    moved = apply_moves_inner(move, data, new)
    result = [{new, moved} | result]
    apply_moves(t, data, new, result)
  end

  def apply_moves_inner([move1, move2], data, new) do
    data = replace(move1, data, new)
    data = replace(move2, data, new)
    Enum.sort(data)
  end
  def apply_moves_inner([move], data, new) do
    data = replace(move, data, new)
    Enum.sort(data)
  end

  def replace({pos1, pos2}, data, new) do
    element = Enum.at(data, pos1)
    element = put_elem(element, pos2, new)
    List.replace_at(data, pos1, element)
  end

  def possible_data({_elevator, data}) do
    Enum.all?(for i <- 0..3, do: possible_floor(i, data))
  end

  def possible_floor(floor, data) do
    chips = elements_in(data, floor, 0)
    generators = elements_in(data, floor, 1)
    lone_chips = chips -- generators
    (length(lone_chips) == 0) || (length(generators) == 0)
  end

  def elements_in(data, floor, i) do
    data
      |> Enum.map(&(elem(&1, i)))
      |> Enum.with_index
      |> Enum.filter_map(fn({e, i}) -> e == floor end, &(elem(&1, 1)))
  end

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Parse.parse
      |> brute_force
  end
end

input = "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.
"
{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
