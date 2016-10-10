defmodule Orientex.QueryTest do
  use ExUnit.Case

  alias Orientex.Query

  test "Query struct" do
    query = %Query{}
    assert query.name == ""
    assert query.request == nil
    assert query.session_id == nil
    assert query.statement == ""
  end
end
