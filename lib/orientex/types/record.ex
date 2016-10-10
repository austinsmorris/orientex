defmodule Orientex.Types.Record do
  @moduledoc false

  alias Orientex.Document
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



  def encode({:varint, value}) do
    value |> do_encode_zigzag() |> do_encode_varint
  end

  def encode({:varint_string, value}) do
    encode({:varint, byte_size(value)}) <> value
  end

  defp do_encode_varint(value) when value >= 0 and value <= 127, do: <<value>>
  defp do_encode_varint(value) when value > 127 do
    <<1 :: 1, Bitwise.band(value, 127) :: 7, do_encode_varint(Bitwise.bsr(value, 7)) :: binary>>
  end

  defp do_encode_zigzag(value) when value >= 0, do: value * 2
  defp do_encode_zigzag(value) when value < 0, do: -(value * 2) - 1



  def encode(%Document{} = record) do
    # todo - (serialization-version:byte)(class-name:string)(header:byte[])(data:byte[])
    serialization_version = Types.encode({:byte, 0})
    class_name = Types.encode({:string, record.class})
    header_and_data = do_encode_properties(record.properties, byte_size(serialization_version <> class_name))
    serialization_version <> class_name <> header_and_data
  end

  defp do_encode_properties(%{} = properties, pointer) do
    {properties_list, new_pointer} = Enum.reduce(properties, {[], pointer}, fn({property, value}, {list, pointer}) ->
      # propery is a string value
      encoded_field_name = encode({:varint_string, property})

      data_type = get_property_data_type(value)
      encoded_data_type = Types.encode({:byte, Types.get_data_type(data_type)})

      pointer = pointer + byte_size(encoded_field_name <> <<0 :: signed-size(32)>> <> encoded_data_type)

      encoded_data = do_encode_record_data(data_type, value)

      {[{encoded_field_name, encoded_data_type, encoded_data} | list], pointer}
    end)

    foo = Enum.reverse(properties_list)

    header_end = encode({:varint, 0})
    {encoded_header, encoded_data, _} = Enum.reduce(
      foo,
      {<<>>, <<>>, new_pointer + byte_size(header_end)},
      fn({encoded_field_name, encoded_data_type, encoded_data}, {header, data, offset}) ->
        new_header = header <> encoded_field_name <> <<offset :: signed-size(32)>> <> encoded_data_type
        {new_header, data <> encoded_data, offset + byte_size(encoded_data)}
      end
    )

    encoded_header <> header_end <> encoded_data
  end



  defp do_encode_record_data(:string, value), do: encode({:varint_string, value})
  defp do_encode_record_data(:embedded_map, value), do: encode({:varint_string, value})

  defp get_property_data_type(value) when is_binary(value), do: :string
  defp get_property_data_type(%{} = value), do: :embedded_map
end
