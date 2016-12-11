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

  def execute(list), do: execute(list, 1, [], [])
  def execute([], result, [], _store), do: result
  def execute([], result, missed, store), do: execute(missed, result, [], store)
  def execute([head | tail], result, missed, store) do
    {result, missed, store} = run(head, result, missed, store)
    execute(tail, result, missed, store)
  end

  def run({b, v}, result, missed, store) do
    {result, store} = put_value({:b, b}, v, result, store)
    {result, missed, store}
  end
  def run({b, l, h}, result, missed, store) do
    key = Keyword.get(store, b)
    move({b, l, h}, result, missed, store, key)
  end

  def put_value({:b, b}, v, result, store) do
    old = Keyword.get(store, b) || {}
    new = insert(old, v)
    store = Keyword.put(store, b, new)
    {result, store}
  end
  def put_value({:o, o}, v, result, store) do
    IO.puts "Output #{o} value #{v}"
    if (Enum.member?([:"0", :"1", :"2"], o)) do
      result = result * v
    end
    {result, store}
  end

  def move({b, l, h}, result, missed, store, {v1, v2} = items) do
    store = Keyword.delete(store, b)
    {result, store} = put_value(h, v2, result, store)
    {result, store} = put_value(l, v1, result, store)
    {result, missed, store}
  end
  def move(operation, result, missed, store, _), do: {result, [operation | missed], store}

  def insert({}, v), do: {v}
  def insert({e}, v) when e > v, do: {v, e}
  def insert({e}, v) when e < v, do: {e, v}

  def type("bot " <> b), do: {:b, String.to_atom(b)}
  def type("output " <> o), do: {:o, String.to_atom(o)}

  def calculate(input) do
    input
      |> String.split("\n")
      |> List.delete_at(-1)
      |> iterate
      |> execute
  end
end

{:ok, input} = File.read("input.txt")
IO.puts input

result = Task.calculate(input)
IO.inspect result
