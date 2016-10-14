defmodule Orientex.Types.RecordTest do
  use ExUnit.Case

  alias Orientex.Document
  alias Orientex.Types.Record

  test "encode empty record" do
    encoded = Record.encode(%Document{})
    assert encoded == <<0, 0, 0>>
  end

  test "encode record" do
    encoded = Record.encode(%Document{class: "Test", properties: %{"foo" => "bar", "baz" => "bat"}})
    assert encoded == <<0, 8, 84, 101, 115, 116, 6, 98, 97, 122, 0, 0, 0, 25, 7, 6, 102, 111, 111, 0, 0, 0, 29, 7, 0,
      6, 98, 97, 116, 6, 98, 97, 114>>
  end

  test "encode record with an embedded map" do
    encoded = Record.encode(%Document{class: "Test", properties: %{"foo" => %{"0" => "bar"}}})
    assert encoded == <<0, 8, 84, 101, 115, 116, 6, 102, 111, 111, 0, 0, 0, 16, 12, 0, 2, 7, 2, 48, 0, 0, 0,
      25, 7, 6, 98, 97, 114>>
  end

  test "encode varint" do
    assert Record.encode({:varint, 0}) == <<0>>
    assert Record.encode({:varint, 47}) == <<94>>
    assert Record.encode({:varint, 267}) == <<150, 4>>
    assert Record.encode({:varint, -12345}) == <<241, 192, 1>>
  end

  test "encode varint string" do
    assert Record.encode({:varint_string, "foo"}) == <<6, 102, 111, 111>>
  end

  test "encode embedded map with pointer 0" do
    encoded = Record.encode({:embedded_map, %{"foo" => "bar"}}, 0)
    assert encoded == <<2, 7, 6, 102, 111, 111, 0, 0, 0, 11, 7, 6, 98, 97, 114>>
  end

    test "encode embedded map with pointer 1234" do
      encoded = Record.encode({:embedded_map, %{"foo" => "bar"}}, 1234)
      assert encoded == <<2, 7, 6, 102, 111, 111, 0, 0, 4, 221, 7, 6, 98, 97, 114>>
    end
end
