defmodule Task do
  def parse_line(string) do
    result = [
      swap: ~r/swap position (\d) with position (\d)/,
      swap_letter: ~r/swap letter (\w) with letter (\w)/,
      rotate: ~r/rotate (left|right) (\d) step/,
      rotate_letter: ~r/rotate based on position of letter (\w)/,
      reverse: ~r/reverse positions (\d) through (\d)/,
      move: ~r/move position (\d) to position (\d)/
    ]
    Enum.reduce(result, false, &(parse(&1, &2, string)))
  end

  def parse({key, regex}, false, charlist) do
    result = Regex.run(regex, charlist, capture: :all_but_first)
    if (result), do: {key, result}, else: false
  end
  def parse(_, result, _charlist), do: result

  def run_list([], charlist), do: charlist
  def run_list([h | t], charlist) do
    IO.inspect(h)
    charlist = run(h, charlist)
    IO.puts(charlist)
    run_list(t, charlist)
  end

  def to_int(list), do: Enum.map(list, &String.to_integer/1)

  def run({:swap, [a, b]}, charlist) do
    [a, b] = to_int([a, b])
    ca = Enum.at(charlist, a)
    cb = Enum.at(charlist, b)
    charlist = List.replace_at(charlist, a, cb)
    charlist = List.replace_at(charlist, b, ca)
    charlist
  end
  def run({:swap_letter, [a, b]}, charlist) do
    charlist
      |> List.to_string
      |> String.replace(a, "_")
      |> String.replace(b, a)
      |> String.replace("_", b)
      |> String.to_charlist
  end
  def run({:reverse, [a, b]}, charlist) do
    [a, b] = to_int([a, b])
    {rest, right} = Enum.split(charlist, b + 1)
    {left, middle} = Enum.split(rest, a)
    left ++ Enum.reverse(middle) ++ right
  end
  def run({:rotate, ["left", a]}, charlist) do
    a = String.to_integer(a)
    run_rotate(charlist, -a)
  end
  def run({:rotate, ["right", a]}, charlist) do
    a = String.to_integer(a)
    run_rotate(charlist, a)
  end
  def run({:move, [a, b]}, charlist) do
    [a, b] = to_int([a, b])
    old = Enum.at(charlist, a)
    charlist = List.delete_at(charlist, a)
    List.insert_at(charlist, b, old)
  end
  def run({:rotate_letter, [a]}, charlist) do
    string = List.to_string(charlist)
    {pos, _} = :binary.match(string, a)
    pos = if (pos >= 4), do: pos + 1, else: pos
    run_rotate(charlist, pos + 1)
  end

  def run_rotate(charlist, distance) do
    distance = rem(distance, length(charlist))
    {left, right} = Enum.split(charlist, -distance)
    right ++ left
  end

  def calculate(input, string) do
    charlist = String.to_char_list(string)
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> Enum.map(&parse_line/1)
      |> run_list(charlist)
  end
end

string = "abcdefgh"
{:ok, input} = File.read("input.txt")
IO.puts input
IO.puts string

result = Task.calculate(input, string)
IO.inspect result
