defmodule Orientex.Request.Command do
  @moduledoc false

  alias Orientex.Document
  alias Orientex.Types

  # todo - docs, specs
  def encode(query, params, _opts) do
    class_name = query |> get_class_name_encoding_for_query() |> Types.encode()

    # todo - allow passing in the limit
    # todo - allow fetch plans
    command_payload = Types.encode([
      {:string, query}, # query text
      {:int, -1}, # non-text limit - -1 means use limit in query text
      {:string, ""}, # fetch plan
      get_params_encoding(params), # serialized parameters
    ])

    command_payload_length = IO.iodata_length([class_name, command_payload])

    beginning = Types.encode([
      {:byte, "s"}, #mode - synchronous
      {:int, command_payload_length}, #command payload length
    ])

    beginning <> class_name <> command_payload
  end

  defp get_class_name_encoding_for_query(query) do
    if query =~ ~r/^\s*(SELECT|TRAVERSE).+/i do
      {:string, "q"}
    else
      {:string, "c"}
    end
  end

  defp get_params_encoding([]), do: {:bytes, nil}
  defp get_params_encoding(params) when is_list(params) do
    {:bytes, Types.encode(%Document{properties: %{"params" => params_to_embedded_map(params)}})}
  end

  defp params_to_embedded_map(params) when is_list(params) do
    params
    |> Stream.with_index()
    |> Stream.map(fn({value, index}) -> {to_string(index), value} end)
    |> Enum.into(%{})
  end
end
