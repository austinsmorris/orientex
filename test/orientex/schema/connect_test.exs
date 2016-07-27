defmodule Orientex.Schema.ConnectTest do
  use ExUnit.Case

  alias Orientex.Schema.Connect

  test "the proper schema is returned" do
    schema = [:byte, :int, :int, :bytes]
    assert Connect.get_schema() == schema
  end
end
