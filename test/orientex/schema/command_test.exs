defmodule Orientex.Schema.CommandTest do
  use ExUnit.Case

  alias Orientex.Schema.Command

  test "the proper schema is returned" do
    [a, b, c, d] = Command.get_schema()
    assert a == :byte
    assert b == :int
    assert c == :byte
    assert is_function(d) == true
  end

  test "the proper schema is returned for list of records" do
    [_, _, _, d] = Command.get_schema()
    schema = d.(108)
    assert schema == [{:int, [:short, :byte, :short, :long, :int, :record]}, :byte]
  end

  test "the proper schema is returned for null result" do
    [_, _, _, d] = Command.get_schema()
    schema = d.(110)
    assert schema == [:byte]
  end

  test "the proper schema is returned for wrapped single record" do
    [_, _, _, d] = Command.get_schema()
    schema = d.(119)
    assert schema == [[:short, :byte, :short, :long, :int, :record], :byte]
  end
end
