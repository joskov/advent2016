defmodule Task do
  def calculate(input) do
    find_crypt(input, 0, 0, "")
  end

  def pattern_check("00000" <> rest, index) do
    char = String.slice(rest, 0, 1)
    IO.puts("#{char} at #{index}")
    {char, 1}
  end
  def pattern_check(_, _), do: {"", 0}

  def find_crypt(_input, _index, 8, result), do: result
  def find_crypt(input, index, found, result) do
    hash = :crypto.hash(:md5, "#{input}#{index}") |> Base.encode16(case: :lower)
    {char, inc} = pattern_check(hash, index)
    find_crypt(input, index + 1, found + inc, result <> char)
  end
end

# input = "abc"
input = "uqwqemis"

IO.puts input

result = Task.calculate(input)
IO.inspect result
