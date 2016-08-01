defmodule Orientex.Query do
  @moduledoc false

  alias Orientex.Request
  alias Orientex.Response
  alias Orientex.Types

  defstruct request: nil, session_id: nil, query: ""

  defimpl DBConnection.Query do
    # todo - test
    @spec decode(any, any, Keyword.t) :: any
    def decode(%Orientex.Query{request: request}, result, opts) do
      Response.decode(request, result)
    end

    #todo - test
    @spec describe(any, Keyword.t) :: any
    def describe(query, opts) do
      query
    end

    # todo - test
    @spec encode(any, any, Keyword.t) :: any
    def encode(%Orientex.Query{request: request, session_id: session_id, query: query} = q, params, opts) do
      Request.encode(request, session_id, query, params, opts)
    end

    # todo - test
    @spec parse(any, Keyword.t) :: any
    def parse(query, opts) do
      query
    end
  end
end