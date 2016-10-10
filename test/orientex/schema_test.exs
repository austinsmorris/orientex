defmodule Orientex.SchemaTest do
  use ExUnit.Case

  alias Orientex.Schema

  test "Schema struct" do
    schema = %Schema{}
    assert schema.progress == []
    assert schema.result == []
    assert schema.schema == []
  end

  test "the proper schema is returned for :request_connect" do
    schema = Schema.get_schema_for_request(:request_connect)
    assert schema.schema == Schema.Connect.get_schema()
  end

  test "the proper schema is returned for :request_db_open" do
    schema = Schema.get_schema_for_request(:request_db_open)
    assert schema.schema == Schema.DbOpen.get_schema()
  end

  test "the proper schema is returned for :request_command" do
    schema = Schema.get_schema_for_request(:request_command)
    assert schema.schema == Schema.Command.get_schema()
  end
end
