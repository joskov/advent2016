defmodule Task do
  def calculate(input) do
    result = find_crypt(input, 0, [])
    inspect_password(result)
  end

  def inspect_password(result) do
    result
      |> fill_blank(Enum.to_list(?0..?7))
      |> Enum.sort
      |> Keyword.values
      |> Enum.join
  end

  def fill_blank(result, []), do: result
  def fill_blank(result, [head | tail]) do
    result = Keyword.put_new(result, List.to_atom([head]), "_")
    fill_blank(result, tail)
  end

  def pattern_check("00000" <> rest, result) do
    position = String.slice(rest, 0, 1)
    char = String.slice(rest, 1, 1)
    IO.puts("#{char} at position #{position}")
    pattern_check_result(position, char, result)
  end
  def pattern_check(_, result), do: result

  def pattern_check_result(pos, char, result) when pos <= "7" do
    result = Keyword.put_new(result, String.to_atom(pos), char)
    IO.puts("Current password #{inspect_password(result)}")
    result
  end
  def pattern_check_result(_, _, result), do: result

  def find_crypt(_input, _index, result) when length(result) == 8, do: result
  def find_crypt(input, index, result) do
    hash = :crypto.hash(:md5, "#{input}#{index}") |> Base.encode16(case: :lower)
    result = pattern_check(hash, result)
    find_crypt(input, index + 1, result)
  end
end

# input = "abc"
input = "uqwqemis"

IO.puts input

result = Task.calculate(input)
IO.inspect result
