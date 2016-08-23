defmodule Orientex.Types.Record do
  @moduledoc false

  alias Orientex.Types
  use Bitwise, skip_operators: true

  # todo - docs, specs, test
  def decode(data) do
    {:ok, serialization_version, tail} = Types.decode(:byte, data)
    {class_name, record_tail} = decode(:varint_string, tail)
    {serialization_version, class_name, record_tail}
  end

  # varint
  def decode(:varint, data) do
    do_decode_varint(data, 0, 0)
  end

  def decode(:varint_string, data) do
    {length, tail} = do_decode_varint(data, 0, 0)
    {:ok, varint_string, varint_string_tail} = Types.decode_binary(length, tail)
    {varint_string, varint_string_tail}
  end

  def decode(:link, data) do
    {cluster_id, tail} = decode(:varint, data)
    {cluster_position, link_tail} = decode(:varint, tail)
    {{cluster_id, cluster_position}, link_tail}
  end

  defp do_decode_varint(<<1 :: 1, value :: 7, tail :: binary>>, shift, acc) do
    do_decode_varint(tail, shift + 7, Bitwise.bsl(value, shift) + acc)
  end
  defp do_decode_varint(<<0 :: 1, value :: 7, tail :: binary>>, shift, acc) do
    do_decode_zigzag(Bitwise.bsl(value, shift) + acc, tail)
  end

  defp do_decode_zigzag(zigzag, tail) when rem(zigzag, 2) == 0, do: {div(zigzag, 2), tail}
  defp do_decode_zigzag(zigzag, tail) when rem(zigzag, 2) == 1, do: {-div(zigzag, 2) - 1, tail}
end
