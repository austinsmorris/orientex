defmodule Orientex.Response do
  @moduledoc false

  # todo - docs, specs, test
  def decode(:request_command, result) do
    __MODULE__.Command.parse(result)
  end
end
