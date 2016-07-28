defmodule Orientex.TokenizerTest do
  use ExUnit.Case

  alias Orientex.Schema
  alias Orientex.Tokenizer

  test "when all data has been tokenized, the result is reversed" do
    schema = %Schema{result: [1, 2, 3, 4]}
    {:ok, result} = Tokenizer.tokenize(schema, <<>>)
    assert result == [4, 3, 2, 1]
  end

  test "tokenized data is returned when data is coplete" do
    schema = %Schema{schema: [:short, :byte]}
    {:ok, result} = Tokenizer.tokenize(schema, <<1, 1, 4>>)
    assert result == [257, 4]
  end

  test "remaining data is returned when data is incomplete" do
    data = <<1, 0, 0, 0, 4, 123, 123>>
    schema = %Schema{schema: [:byte, :string]}
    {:incomplete, %Schema{progress: [], result: result, schema: schema}, tail} = Tokenizer.tokenize(schema, data)
    assert result == [1]
    assert schema == [:string]
    assert tail == <<0, 0, 0, 4, 123, 123>>
  end

  test "remaining data and progress is returned when compound data is incomplete" do
    data = <<1, 0, 0, 0, 4, 0, 1, 0, 2, 31>>
    schema = %Schema{schema: [:byte, {:int, [:short]}, :int]}
    {:incomplete, %Schema{progress: progress, result: result, schema: schema}, tail} = Tokenizer.tokenize(schema, data)
    assert progress == {4, [[1], [2]]}
    assert result == [1]
    assert schema == [{:int, [:short]}, :int]
    assert tail == <<31>>
  end
end
