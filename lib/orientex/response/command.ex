defmodule Orientex.Response.Command do
  @moduledoc false

  alias Orientex.Document
  alias Orientex.Result
  alias Orientex.RID
  alias Orientex.Types
  alias Orientex.Types.Record

  # todo - docs, specs, test
  def parse([success, session_id, result_type | tail]) do
    {num_rows, rows, content} = parse_result(<<result_type>>, tail)
    %Result{content: content, num_rows: num_rows, rows: rows, session_id: session_id, success: success}
  end

  defp parse_result("l", [{count, records}, 0]) do
    {rows, content} = Enum.reduce(records, {[], []}, fn(record, {acc_rows, acc_content}) ->
      {row, parsed_record} = parse_record(record)
      {[row | acc_rows], [parsed_record, acc_content]}
    end)

    {count, rows, Enum.reverse(content)}
  end

  defp parse_result("n", [0]) do
    {0, [], nil}
  end

  defp parse_result("w", [record, 0]) do
    # fixme - pretty sure this is broken now.  It needs to return {num_rows, rows, content}.
    parse_record(record)
  end

  defp parse_record([0, 100 | record]) do # full record, document (100 == "d")
    [cluster_id, cluster_position, record_version, content] = record
    {_serialization_version, class_name, data} = Record.decode(content)
    {row, properties} = parse_properties(data, content, {[], %{}})

    {row, %Document{
      class: class_name,
      properties: properties,
      rid: %RID{cluster_id: cluster_id, cluster_position: cluster_position},
      version: record_version,
    }}
  end

  defp parse_properties(<<0, _ :: binary>> = _content, _data, acc), do: acc # the end of the header
  defp parse_properties(content, data, {acc_row, acc_properties}) do
    {key, value, tail} = content |> parse_header_property_type() |> parse_header_property() |> parse_property(data)
    parse_properties(tail, data, {acc_row ++ [value], Map.put(acc_properties, key, value)})
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
  defp parse_property({key, position, 13, header_tail}, data) do # 13 = link
    {{cluster_id, cluster_position}, _} = Record.decode(:link, get_data_at_position(position, data))
    {key, %RID{cluster_id: cluster_id, cluster_position: cluster_position}, header_tail}
  end

  defp get_data_at_position(position, data) do
    << _ :: bytes-size(position), value :: binary>> = data
    value
  end
end
