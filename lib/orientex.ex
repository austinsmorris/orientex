defmodule Orientex do
  # alias Orientex.Query

  # @default_opts []

  @spec start_link(Keyword.t) :: {:ok, pid} | {:error, any}
  def start_link(opts \\ []) do
    DBConnection.start_link(Orientex.Protocol, opts)
  end

  # def command(conn, query, params, opts \\ []) do
  #   DBConnection.prepare_execute(conn, %Query{request: :request_command, query: query}, params, opts)
  # end
end
