defmodule Orientex.ResultTest do
  use ExUnit.Case

  alias Orientex.Result

  test "Result struct" do
    result = %Result{}
    assert result.content == nil
    assert result.num_rows == nil
    assert result.rows == nil
    assert result.success == nil
    assert result.session_id == nil
    assert result.token == nil
  end
end
