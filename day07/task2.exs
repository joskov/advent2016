defmodule Task do
  def mirrored(text) do
    result = Regex.scan(~r/(?=([a-z])(?!\1)([a-z])\1)/, text, capture: :all_but_first)
    result = Enum.map(result, &Enum.join/1)
  end

  def correct_ip(ip) do
    negative =
      Regex.scan(~r/\[([a-z]+)\]/, ip, capture: :all_but_first)
      |> Enum.map(&hd/1)
      |> Enum.map(&mirrored/1)
      |> List.flatten
      |> Enum.map(&String.reverse/1)

    ip = String.replace(ip, ~r/\[([a-z]+)\]/, "|")
    positive =
      Regex.scan(~r/[a-z]*/, ip)
      |> Enum.map(&hd/1)
      |> Enum.map(&mirrored/1)
      |> List.flatten

    length(positive -- (positive -- negative)) > 0
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
