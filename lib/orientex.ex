defmodule Orientex do
  @moduledoc """
  An OrientDB network binary protocol driver for Elixir using DBConnection.
  """

  alias Orientex.Query

  @default_opts [
    host: :localhost,
    port: 2424,
    username: "root",
    password: "",
  ]

  @version Mix.Project.config[:version]

  @spec start_link(Keyword.t) :: {:ok, pid} | {:error, any}
  def start_link(opts \\ []) do
    DBConnection.start_link(Orientex.Protocol, Keyword.merge(@default_opts, opts))
  end

  def command(conn, query, params, opts \\ []) do
    DBConnection.prepare_execute(conn, %Query{request: :request_command, query: query}, params, opts)
  end

  def version, do: @version
end
