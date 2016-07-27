defmodule Orientex.Schema.DbOpenTest do
  use ExUnit.Case

  alias Orientex.Schema.DbOpen

  test "the proper schema is returned" do
    schema = [:byte, :int, :int, :bytes, {:short, [:string, :short]}, :bytes, :string]
    assert DbOpen.get_schema() == schema
  end
end
