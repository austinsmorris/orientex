defmodule Orientex.Types do
  @moduledoc false

  # Decode!

  # boolean
  def decode(:boolean, <<0, tail :: binary>>), do: {:ok, false, tail}
  def decode(:boolean, <<1, tail :: binary>>), do: {:ok, true, tail}

  # byte
  def decode(:byte, <<value, tail :: binary>>), do: {:ok, value, tail}

  # integers
  def decode(:short, <<value :: signed-size(16), tail :: binary>>), do: {:ok, value, tail}
  def decode(:short, tail), do: {:incomplete, nil, tail}

  def decode(:int, <<value :: signed-size(32), tail :: binary>>), do: {:ok, value, tail}
  def decode(:int, tail), do: {:incomplete, nil, tail}

  def decode(:long, <<value :: signed-size(64), tail :: binary>>), do: {:ok, value, tail}
  def decode(:long, tail), do: {:incomplete, nil, tail}

  # binary data
  # todo - test
  def decode(:bytes, data) when is_binary(data), do: decode(:binary, data)
  def decode(:record, data) when is_binary(data), do: decode(:binary, data)
  def decode(:string, data) when is_binary(data), do: decode(:binary, data)

  def decode(:binary, <<length :: signed-size(32), value :: binary>> = data) when is_binary(data) do
    decode_binary(length, value)
  end
  def decode(:binary, tail), do: {:incomplete, nil, tail}

  # compound types
  # todo - test
  def decode({count_type, template}, data) when is_list(template)do
    case decode(count_type, data) do
      {:ok, count, tail} ->
        decode_compound_data(template, {count, []}, tail)
      {:incomplete, nil, tail} ->
        {:incomplete, nil, tail}
    end
  end
  def decode({count_type, template}, value, data) when is_list(template) do
    decode_compound_data(template, value, data)
  end

  def decode_compound_data(_, {count, values} = value, tail) when count == length(values) do
    {:ok, value, tail}
  end
  def decode_compound_data(template, {count, values}, data) when is_list(values) do
    case decode(template, data) do
      {:ok, value, tail} ->
        decode_compound_data(template, {count, values ++ [value]}, tail)
      {:incomplete, nil, tail} ->
        {:incomplete, {count, values}, tail}
    end
  end

  def decode(template, data) when is_list(template) do
    case do_decode_list(template, data, []) do
      {:ok, value, tail} ->
        {:ok, value, tail}
      {:incomplete, _, _} ->
        {:incomplete, nil, data}
    end
  end

  def decode_binary(-1, data), do: {:ok, nil, data}
  def decode_binary(length, data) when byte_size(data) >= length do
    <<value :: bytes-size(length), tail :: binary>> = data
    {:ok, value, tail}
  end
  def decode_binary(length, data) do
    {:incomplete, nil, <<length :: signed-size(32), data :: binary>>}
  end

  defp do_decode_list([type | []], data, acc) do
    case decode(type, data) do
      {:ok, value, tail} ->
        {:ok, acc ++ [value], tail}
      {:incomplete, nil, tail} -> {:incomplete, acc, data}
    end
  end
  defp do_decode_list([type | type_tail], data, acc) do
    case decode(type, data) do
      {:ok, value, tail} -> do_decode_list(type_tail, tail, acc ++ [value])
      {:incomplete, nil, tail} -> {:incomplete, acc, data}
    end
  end

  # Encode!
  # todo - test

  def encode(list) when is_list(list) do
    Enum.reduce(list, <<>>, fn(value, acc) -> acc <> encode(value) end)
  end

  # in OrientDB, all instances of NULL are sent as a -1 in 4 bytes
  def encode(:nil), do: encode({:int, -1})

  # boolean
  def encode(:false), do: <<0>>
  def encode(:true), do: <<1>>
  def encode({:boolean, value}) when is_boolean(value), do: <<value>>

  # byte
  # todo - product against multi-byte strings
  def encode({:byte, value}) when is_binary(value), do: value
  def encode({:byte, value}) when is_integer(value) and value >= -128 and value <= 127, do: <<value>>

  # todo - default integer encoding?

  # short, int, and long
  def encode({:short, value}) when is_integer(value) and value >= -32_768 and value <= 32_767, do: <<value :: signed-size(16)>>
  def encode({:int, value}) when is_integer(value) and value >= -2_147_483_648 and value <= 2_147_483_647, do: <<value :: signed-size(32)>>
  def encode({:long, value}) when is_integer(value) and value >= -9_223_372_036_854_775_808 and value <= 9_223_372_036_854_775_807, do: <<value :: signed-size(64)>>

  # bytes and strings
  def encode({:bytes, value}) when is_binary(value), do: encode(value)
  def encode({:string, value}) when is_binary(value), do: encode(value)
  def encode(value) when is_binary(value), do: encode({:int, byte_size(value)}) <> value

  # todo - record
  # def encode(value), do:

  # strings
  def encode({:strings, value}) when is_list(value) do
    encode({:int, length(value)}) <> Enum.reduce(value, <<>>, fn(string, acc) -> acc <> encode({:string, string}) end)
  end
end
