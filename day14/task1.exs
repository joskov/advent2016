defmodule Task do
  # @input "abc"
  @input "jlmsuwbz"

  def calculate() do
    calculate(0, thousand_hashes, [])
  end

  def calculate(index, _quintuples, result) when length(result) >= 64 do
    IO.inspect(Enum.reverse(result))
    IO.puts(index - 1)
  end
  def calculate(index, quintuples, result) do
    quintuples = move_thousand_hashes(quintuples)
    hash = hash(index)
    triple = check_for_triple(hash)
    result = add_triple(index, triple, quintuples, result)
    calculate(index + 1, quintuples, result)
  end

  def thousand_hashes() do
    for n <- 0..999, do: hash_with_info(n)
  end

  def move_thousand_hashes([_h | tail]) do
    {n, _, _} = Enum.at(tail, -1)
    tail ++ [hash_with_info(n + 1)]
  end

  def hash_with_info(index) do
    hash = hash(index)
    {index, hash, check_for_quintuples(hash)}
  end

  def hash(index) do
    @input <> Integer.to_string(index)
      |> :crypto.md5
      |> Base.encode16
  end

  def check_for_triple(hash) do
    Regex.run(~r/(.)\1\1/, hash)
  end

  def check_for_quintuples(hash) do
    Regex.run(~r/(.)\1\1\1\1/, hash) || []
      |> Enum.map(&(Enum.at(&1, 1)))
      |> Enum.uniq
  end

  def add_triple(index, [_, char], quintuples, result) do
    found = Enum.any?(quintuples, &(Enum.member?(elem(&1, 2), char)))
    if (found) do
      [{index, char} | result]
    else
      result
    end
  end
  def add_triple(_index, nil, _quintuples, result), do: result
end

result = Task.calculate
IO.inspect result
