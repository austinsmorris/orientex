defmodule Orientex.Request.CommandTest do
  use ExUnit.Case

  alias Orientex.Request.Command

  test "encode an idempotent SELECT query without params" do
    data = Command.encode("SELECT foo", [], [])
    assert data == <<115, 0, 0, 0, 31, 0, 0, 0, 1, 113, 0, 0, 0, 10, 83, 69, 76, 69, 67, 84, 32, 102, 111, 111,
      255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "encode an idempotent TRAVERSE query without params" do
    data = Command.encode("TRAVERSE foo", [], [])
    assert data == <<115, 0, 0, 0, 33, 0, 0, 0, 1, 113, 0, 0, 0, 12, 84, 82, 65, 86, 69, 82, 83, 69, 32, 102, 111, 111,
      255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
  end


  test "encode an idempotent query with params list" do
    data = Command.encode("SELECT foo WHERE bar = ?", ["bat"], [])
    assert data == <<115, 0, 0, 0, 73, 0, 0, 0, 1, 113, 0, 0, 0, 24, 83, 69, 76, 69, 67, 84, 32, 102, 111, 111, 32, 87,
      72, 69, 82, 69, 32, 98, 97, 114, 32, 61, 32, 63, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 28, 0, 0, 12, 112, 97,
      114, 97, 109, 115, 0, 0, 0, 15, 12, 0, 2, 7, 2, 48, 0, 0, 0, 24, 7, 6, 98, 97, 116>>
    end

  test "encode a command" do
    data = Command.encode("foo", [], [])
    assert data == <<115, 0, 0, 0, 24, 0, 0, 0, 1, 99, 0, 0, 0, 3, 102, 111, 111,
      255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
  end
end
