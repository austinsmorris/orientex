defmodule OrientexTest do
  use ExUnit.Case
  # doctest Orientex

  test "version() returns the current version" do
    assert Orientex.version() == Mix.Project.config[:version]
  end
end
