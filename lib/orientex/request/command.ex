defmodule Orientex.Request.Command do
  @moduledoc false

  alias Orientex.Types

  # todo - docs, specs, test
  def encode(query, _params, _opts) do
    class_name = query |> get_class_name_encoding_for_query() |> Types.encode()

    # todo - allow passing in the limit
    # todo - allow fetch plans
    # todo - allow serialized parameters
    command_payload = Types.encode([
      {:string, query}, # query text
      {:int, -1}, #non-text limit - -1 means use limit in query text
      {:string, ""}, # fetch plan
      {:string, ""}, # serialized parameters
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
end
