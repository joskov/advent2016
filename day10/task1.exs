defmodule Task do
  def iterate(list), do: iterate(list, [])
  def iterate([], result), do: result
  def iterate([head | tail], result) do
    iterate(tail, [parse(head) | result])
  end

  def parse("value " <> string) do
    [_, v, b] = Regex.run(~r/(\d+) goes to bot (\d+)/, string)
    {String.to_atom(b), String.to_integer(v)}
  end
  def parse("bot " <> string) do
    [_, b, l, h] = Regex.run(~r/(\d+) gives low to (.*) and high to (.*)/, string)
    {String.to_atom(b), type(l), type(h)}
  end

  def execute(list, check), do: execute(list, check, [], [])
  def execute([], _check, [], result), do: result
  def execute([], check, missed, result), do: execute(missed, check, [], result)
  def execute([head | tail], check, missed, result) do
    {missed, result} = run(head, check, missed, result)
    execute(tail, check, missed, result)
  end

  def run({b, v}, _check, missed, result) do
    {missed, put_value({:b, b}, v, result)}
  end
  def run({b, l, h}, check, missed, result) do
    key = Keyword.get(result, b)
    move({b, l, h}, check, missed, result, key)
  end

  def put_value({:b, b}, v, result) do
    old = Keyword.get(result, b) || {}
    new = insert(old, v)
    Keyword.put(result, b, new)
  end
  def put_value({:o, o}, v, result) do
    # IO.puts "Output #{o} value #{v}"
    result
  end

  def move({b, l, h}, check, missed, result, {v1, v2} = items) do
    if (check == items) do
      IO.puts "Bot #{b} comparing #{v1} and #{v2}"
    end
    result = Keyword.delete(result, b)
    result = put_value(h, v2, result)
    result = put_value(l, v1, result)
    {missed, result}
  end
  def move(operation, _check, missed, result, _), do: {[operation | missed], result}

  def insert({}, v), do: {v}
  def insert({e}, v) when e > v, do: {v, e}
  def insert({e}, v) when e < v, do: {e, v}

  def type("bot " <> b), do: {:b, String.to_atom(b)}
  def type("output " <> o), do: {:o, String.to_atom(o)}

  def calculate(input, check) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> iterate
      |> execute(check)
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

check = {17, 61}

result = Task.calculate(input, check)
IO.inspect result
