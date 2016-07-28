defmodule Orientex.Protocol do
  @moduledoc false

  # todo - test!

  # alias Orientex.Query
  alias Orientex.Request
  alias Orientex.Schema
  alias Orientex.Tokenizer
  alias Orientex.Types

  use DBConnection

  defstruct protocol_version: :nil, session_id: nil, socket: :nil

  @protocol_version 36
  @timeout 1_000

  @spec connect(opts :: Keyword.t) :: {:ok, state :: any} | {:error, Exception.t}
  def connect(opts) do
    host = Keyword.get(opts, :host)
    port = Keyword.get(opts, :port)
    request = if Keyword.has_key?(opts, :db), do: :request_db_open, else: :request_connect

    # todo - using :gen_tcp for now, should be configurable to use :ssl
    # todo - get tcp settings from options
    # todo - error handling for connect
    case :gen_tcp.connect(host, port, [packet: :raw, mode: :binary, active: false], @timeout) do
      {:ok, socket} ->
        # todo - error handling for protocol negotiation including minimum version
        {:ok, <<protocol_version :: signed-size(16)>>} = :gen_tcp.recv(socket, 0, @timeout)

        # todo = error check send
        :ok = :gen_tcp.send(socket, encode_connect_request(request, opts))

        # todo - error check get_data
        {:ok, result} = get_data(Schema.get_schema_for_request(request), :gen_tcp, socket)

        # todo - error check response data
        # todo - validate request session id is nil
        # todo - do something with db cluster data, cluster config, orientdb-release
        [success, request_session_id, session_id | _] = result

        {:ok, %__MODULE__{protocol_version: protocol_version, session_id: session_id, socket: {:gen_tcp, socket}}}
    end
  end

  @spec checkout(state :: any) :: {:ok, new_state :: any} | {:disconnect, Exception.t, new_state :: any}
  def checkout(state), do: {:ok, state}

  @spec checkin(state :: any) :: {:ok, new_state :: any} | {:disconnect, Exception.t, new_state :: any}
  def checkin(state), do: {:ok, state}

  # @spec ping(state :: any) :: {:ok, new_state :: any} | {:disconnect, Exception.t, new_state :: any}

  # @spec handle_prepare(DBConnection.query, opts :: Keyword.t, state :: any) ::
  #   {:ok, DBConnection.query, new_state :: any} | {:error | :disconnect, Exception.t, new_state :: any}
  # def handle_prepare(%Query{request: request, query: query}, opts, state) do
  #   {:ok, %Query{request: request, session_id: state.session_id, query: query}, state}
  # end

  # @spec handle_execute(DBConnection.query, DBConnection.params, opts :: Keyword.t, state :: any) ::
  #   {:ok, DBConnection.result, new_state :: any} | {:error | :disconnect, Exception.t, new_state :: any}
  # def handle_execute(%Query{request: request}, params, opts, %__MODULE__{socket: {socket_module, socket}} = state) do
  #   # todo - encapsulate common code for sending request
  #   # todo = error check send
  #   # with db_connection, the encoded query is in the params.
  #   :ok = socket_module.send(socket, params)
  #
  #   # todo - error check get_data
  #   {:ok, result} = get_data(Schema.get_schema_for_request(request), socket_module, socket)
  #
  #   # todo - ensure session id received matches session id in the state
  #   {:ok, result, state}
  # end

  defp encode_connect_request(request, opts) do
    # todo - automatically fetch current version
    a = Types.encode([
      {:byte, Request.get_operation_value(request)}, # operation
      nil, # initial session_id
      "Orientex", # driver name
      "0.0.1", # driver version
      {:short, @protocol_version}, # protocol version
      "", # client id
      "ORecordSerializerBinary", # serialization implementation
      false, # token session
      false, # support push
      false, # collect stats
    ])

    b = if request == :request_db_open, do: Types.encode(Keyword.get(opts, :db, nil)), else: <<>> # db name

    c = Types.encode([
      Keyword.get(opts, :username, ""), # username
      Keyword.get(opts, :password, ""), # password
    ])

    a <> b <> c
  end

  defp get_data(%Schema{} = schema, socket_module, socket, acc \\ <<>>) do
    # todo - configurable timeout
    # todo - error handling for recv
    {:ok, data} = socket_module.recv(socket, 0, @timeout)
    case Tokenizer.tokenize(schema, acc <> data) do
      {:ok, result} -> {:ok, result}
      {:incomplete, new_schema, new_tail} -> get_data(new_schema, socket_module, socket, new_tail)
    end
  end
end
