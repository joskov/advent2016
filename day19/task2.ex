defmodule Task do
  def simulation(_list, index, limit, limit), do: {limit, limit - index}
  def simulation(list, index, size, limit) do
    add_index = rem(index + div(size + 1, 2) - 1, size) + 1
    size = size + 1
    index =
      if (index > add_index) do
        index
      else
        rem(size + index - 1, size)
      end
    # list = List.insert_at(list, add_index, size)
    simulation(list, index, size, limit)
  end

  def calculate(input) do
    simulation([1], 0, 1, input)
  end
end

input = 3014603
result = Task.calculate(input)
IO.inspect result
