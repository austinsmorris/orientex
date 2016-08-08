defmodule Orientex.Request.CommandTest do
  use ExUnit.Case

  alias Orientex.Request.Command

  test "encode an idempotent query" do
    data = Command.encode("SELECT foo", [], [])
    assert data == <<115, 0, 0, 0, 31, 0, 0, 0, 1, 113, 0, 0, 0, 10, 83, 69, 76, 69, 67, 84, 32, 102, 111, 111,
      255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
  end

  test "encode a command" do
    data = Command.encode("foo", [], [])
    assert data == <<115, 0, 0, 0, 24, 0, 0, 0, 1, 99, 0, 0, 0, 3, 102, 111, 111,
      255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0>>
  end
end
