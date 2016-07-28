defmodule Orientex.RequestTest do
  use ExUnit.Case

  alias Orientex.Request

  test "get_operation_value for :request_shutdown" do
    value = Request.get_operation_value(:request_shutdown)
    assert value == 1
  end

  test "get_operation_value for :request_connect" do
    value = Request.get_operation_value(:request_connect)
    assert value == 2
  end

  test "get_operation_value for :request_db_open" do
    value = Request.get_operation_value(:request_db_open)
    assert value == 3
  end
end
