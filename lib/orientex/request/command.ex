defmodule Orientex.Request.Command do
  @moduledoc false

  alias Orientex.Types

  # todo - docs, specs, test
  def encode(query, params, opts) do
    # todo - select between idempotent query and command
    class_name = Types.encode("q") # class name for query
    # class_name = Types.encode("c") # class name for command

    # todo - allow passing in the limit
    # todo - allow fetch plans
    # todo - allow serialized parameters
    command_payload = Types.encode([
      query, # query text
      {:int, -1}, #non-text limit - -1 means use limit in query text
      "", # fetch plan
      "", # serialized parameters
    ])

    command_payload_length = IO.iodata_length([class_name, command_payload])

    beginning = Types.encode([
      {:byte, "s"}, #mode - synchronous
      {:int, command_payload_length}, #command payload length
    ])

    beginning <> class_name <> command_payload
  end
end
