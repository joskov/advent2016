defmodule Task do
  def iterate_lines([], result), do: result
  def iterate_lines([head | tail], result) do
    result = apply_operation(head, result)
    iterate_lines(tail, result)
  end

  def apply_operation("rect " <> rest, result) do
    res = Regex.run(~r/(\d+)x(\d+)/, rest, capture: :all_but_first)
    [w, h] = Enum.map(res, &String.to_integer/1)
    added = for x <- 0..(w - 1), y <- 0..(h - 1), do: {x, y}
    Enum.uniq(added ++ result)
  end
  def apply_operation("rotate row " <> rest, result) do
    res = Regex.run(~r/y=(\d+) by (\d+)/, rest, capture: :all_but_first)
    [y, by] = Enum.map(res, &String.to_integer/1)
    shift_y(result, [], y, by)
  end
  def apply_operation("rotate column " <> rest, result) do
    res = Regex.run(~r/x=(\d+) by (\d+)/, rest, capture: :all_but_first)
    [x, by] = Enum.map(res, &String.to_integer/1)
    shift_x(result, [], x, by)
  end

  def shift_x([], result, _x, _by), do: result
  def shift_x([head | tail], result, x, by) do
    result = [shift_elem_x(head, x, by) | result]
    shift_x(tail, result, x, by)
  end

  def shift_elem_x({x, y}, x, by), do: {x, rem(y + by, 6)}
  def shift_elem_x(result, _x, _by), do: result

  def shift_y([], result, _y, _by), do: result
  def shift_y([head | tail], result, y, by) do
    result = [shift_elem_y(head, y, by) | result]
    shift_y(tail, result, y, by)
  end

  def shift_elem_y({x, y}, y, by), do: {rem(x + by, 50), y}
  def shift_elem_y(result, _y, _by), do: result

  def on_items(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> iterate_lines([])
  end

  def light(_on, 60, _y), do: "\n"
  def light(on, x, y) do
    if (Enum.member?(on, {x, y})), do: "[]", else: "  "
  end

  def calculate(input) do
    on = on_items(input)
    res = for y <- 0..5, x <- 0..60, do: light(on, x, y)
    Enum.join(res)
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
# IO.inspect result
IO.puts result
