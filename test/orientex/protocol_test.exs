defmodule Orientex.ProtocolTest do
  use ExUnit.Case

  alias Orientex.Protocol

  test "Protocol struct" do
    protocol = %Protocol{}
    assert protocol.protocol_version == nil
    assert protocol.session_id == nil
    assert protocol.socket == nil
  end
end
