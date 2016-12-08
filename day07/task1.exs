defmodule Task do
  def mirrored(text) do
    Regex.match?(~r/([a-z])(?!\1)([a-z])\2\1/, text)
  end

  def correct_ip(ip) do
    negative =
      Regex.scan(~r/\[([a-z]*)\]/, ip, capture: :all_but_first)
      |> Enum.map(&hd/1)
      |> Enum.any?(&mirrored/1)

    positive =
      Regex.scan(~r/([a-z]*)/, ip, capture: :all_but_first)
      |> Enum.map(&hd/1)
      |> Enum.any?(&mirrored/1)

    positive && !negative
  end

  def calculate(input) do
    lines = input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&correct_ip/1)
      |> Enum.count(&(&1))
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
