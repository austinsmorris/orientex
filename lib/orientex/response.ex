defmodule Orientex.Response do
  @moduledoc false

  alias Orientex.Types.Record

  defstruct [content: nil ,success: nil, session_id: nil, token: nil]

  # todo - docs, specs, test
  def decode(:request_command, result) do
    __MODULE__.Command.parse(result)
  end
end
