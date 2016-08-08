defmodule Orientex.Response.Command do
  @moduledoc false

  alias Orientex.Document
  alias Orientex.Response
  alias Orientex.RID
  alias Orientex.Types
  alias Orientex.Types.Record

  # todo - docs, specs, test
  def parse([success, session_id, result_type | tail]) do
    %Response{content: parse_result(<<result_type>>, tail), session_id: session_id, success: success}
  end

  defp parse_result("l", [{count, records}, 0]) do
    Enum.map(records, &parse_record/1)
  end

  defp parse_result("n", [0]) do
    nil
  end

  defp parse_result("w", [record, 0]) do
    parse_record(record)
  end

  defp parse_record([0, 100 | record]) do # full record, document (100 == "d")
    [cluster_id, cluster_position, record_version, content] = record
    {_serialization_version, class_name, data} = Record.decode(content)
    properties = parse_properties(data, content, %{})

    %Document{
      class: class_name,
      properties: properties,
      rid: %RID{cluster_id: cluster_id, cluster_position: cluster_position},
      version: record_version,
    }
  end

  defp parse_properties(<<0, _ :: binary>> = foo, data, acc), do: acc # the end of the header
  defp parse_properties(content, data, acc) do
    {key, value, tail} = content |> parse_header_property_type() |> parse_header_property() |> parse_property(data)
    parse_properties(tail, data, Map.put(acc, key, value))
  end

  defp parse_header_property_type(header) do
    Record.decode(:varint, header)
  end

  defp parse_header_property({type, header}) when type > 0 do # named fields
    {:ok, key, tail} = Types.decode_binary(type, header)
    {:ok, [property_position, property_type], header_tail} = Types.decode([:int, :byte], tail)
    {key, property_position, property_type, header_tail}
  end

  defp parse_property({key, position, 0, header_tail}, data) do # 0 = boolean
    {:ok, value, _} = Types.decode(:boolean, get_data_at_position(position, data))
    {key, value, header_tail}
  end
  defp parse_property({key, position, 1, header_tail}, data) do # 1 = int
    {value, _} = Record.decode(:varint, get_data_at_position(position, data))
    {key, value, header_tail}
  end
  defp parse_property({key, position, 2, header_tail}, data) do # 2 = short
    {value, _} = Record.decode(:varint, get_data_at_position(position, data))
    {key, value, header_tail}
  end
  defp parse_property({key, position, 3, header_tail}, data) do # 3 = long
    {value, _} = Record.decode(:varint, get_data_at_position(position, data))
    {key, value, header_tail}
  end
  defp parse_property({key, position, 7, header_tail}, data) do # 7 = string
    {value, _} = Record.decode(:varint_string, get_data_at_position(position, data))
    {key, value, header_tail}
  end

  defp get_data_at_position(position, data) do
    << _ :: bytes-size(position), value :: binary>> = data
    value
  end
end
