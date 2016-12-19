defmodule Task do
  def calculate(input) do
    root = :math.log2(input)
    root = Float.floor(root)
    powered_root = round(:math.pow(2, root))
    rest = input - powered_root
    result = 2 * rest + 1
    result
  end
end

input = 3014603
result = Task.calculate(input)

IO.inspect result
