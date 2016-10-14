defmodule Orientex.Types.Record do
  @moduledoc false

  alias Orientex.Document
  alias Orientex.Types
  use Bitwise, skip_operators: true

  # Decode!

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
    {length, tail} = decode(:varint, data)
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

  # Encode!

  def encode(%Document{} = record) do
    serialization_version = Types.encode({:byte, 0})
    class_name = encode({:varint_string, record.class})
    header_and_data = do_encode_record_properties(record.properties, byte_size(serialization_version <> class_name))
    serialization_version <> class_name <> header_and_data
  end

  def encode({:varint, value}) do
    value |> do_encode_zigzag() |> do_encode_varint
  end

  def encode({:varint_string, nil}), do: encode({:varint_string, ""})
  def encode({:varint_string, value}) when is_binary(value) do
    encode({:varint, byte_size(value)}) <> value
  end

  def encode({:embedded_map, %{} = map}, pointer) do
    encoded_size = encode({:varint, map_size(map)})
    pointer = pointer + get_embedded_map_header_size(map) + byte_size(encoded_size)

    {header, data, _} = Enum.reduce(map, {<<>>, <<>>, pointer}, fn({key, value}, {header_acc, data_acc, pointer}) ->
      key_data_type = get_property_data_type(key)
      value_data_type = get_property_data_type(value)

      encoded_header = Types.encode({:byte, Types.get_data_type(key_data_type)}) <> encode({:varint_string, key}) <>
        <<pointer :: signed-size(32)>> <> Types.encode({:byte, Types.get_data_type(value_data_type)})

      encoded_data = do_encode_record_data(value_data_type, value, pointer)

      {header_acc <> encoded_header, data_acc <> encoded_data, pointer + byte_size(encoded_data)}
    end)

    encoded_size <> header <> data
  end

  defp do_encode_record_properties(nil, pointer), do: do_encode_record_properties(%{}, pointer)
  defp do_encode_record_properties(%{} = properties, pointer) do
    pointer = pointer + get_record_header_size(properties)

    acc = {<<>>, <<>>, pointer}
    {header, data, _} = Enum.reduce(properties, acc, fn({key, value}, {header_acc, data_acc, pointer}) ->
      data_type = get_property_data_type(value)
      encoded_header = encode({:varint_string, key}) <> <<pointer :: signed-size(32)>> <>
        Types.encode({:byte, Types.get_data_type(data_type)})

      encoded_data = do_encode_record_data(data_type, value, pointer)

      {header_acc <> encoded_header, data_acc <> encoded_data, pointer + byte_size(encoded_data)}
    end)

    header <> encode({:varint, 0}) <> data
  end

  defp do_encode_varint(value) when value >= 0 and value <= 127, do: <<value>>
  defp do_encode_varint(value) when value > 127 do
    <<1 :: 1, Bitwise.band(value, 127) :: 7, do_encode_varint(Bitwise.bsr(value, 7)) :: binary>>
  end

  defp do_encode_zigzag(value) when value >= 0, do: value * 2
  defp do_encode_zigzag(value) when value < 0, do: -(value * 2) - 1

  defp do_encode_record_data(:string, value, _pointer), do: encode({:varint_string, value})
  defp do_encode_record_data(:embedded_map, value, pointer), do: encode({:embedded_map, value}, pointer)

  defp get_embedded_map_header_size(%{} = map) do
    Enum.reduce(map, 0, fn({key, _value}, acc) ->
      acc + byte_size(encode({:varint_string, key})) + 6 # 6 = key-type + pointer-to-data + value-type
    end)
  end

  defp get_record_header_size(%{} = properties) do
    # initial accumulator of 1 accounts for the header ending <<0>>
    Enum.reduce(properties, 1, fn({key, value}, acc) ->
      encoded_data_type = Types.encode({:byte, Types.get_data_type(get_property_data_type(value))})
      acc + byte_size(encode({:varint_string, key}) <> <<0 :: signed-size(32)>> <> encoded_data_type)
    end)
  end

  defp get_property_data_type(value) when is_binary(value), do: :string
  defp get_property_data_type(%{} = _value), do: :embedded_map
end
