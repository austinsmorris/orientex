defmodule Orientex.Query do
  @moduledoc false

  defstruct name: "", request: nil, session_id: nil, statement: ""
end

defimpl DBConnection.Query, for: Orientex.Query do
  alias Orientex.Query
  alias Orientex.Request
  alias Orientex.Response
  alias Orientex.Result

  # todo - test
  @spec parse(query :: any, opts :: Keyword.t) :: any
  def parse(%Query{name: name} = query, _opts) do
    # todo - I don't know what this is for... (see postrex or mariaex)
    %Query{query | name: IO.iodata_to_binary(name)}
  end

  #todo - test
  @spec describe(query :: any, opts :: Keyword.t) :: any
  def describe(query, _opts) do
    query
  end

  # todo - test
  @spec encode(query :: any, params :: any, opts :: Keyword.t) :: any
  def encode(%Query{} = query, params, opts) do
    Request.encode(query.request, query.session_id, query.statement, params, opts)
  end

  # todo - test
  @spec decode(query :: any, response :: any, Keyword.t) :: any
  def decode(%Orientex.Query{request: request}, response, opts) do
    mapper = opts[:decode_mapper] || fn x -> x end
    result = Response.decode(request, response)
    rows = do_decode(result, mapper)
    %Result{result | rows: rows}
  end

  defp do_decode(result, mapper) do
    Enum.reduce(result.rows, [], fn(row, acc) -> [mapper.(row) | acc] end)
  end
end

defimpl String.Chars, for: Orientex.Query do
  def to_string(%Orientex.Query{statement: statement}) do
    IO.iodata_to_binary(statement)
  end
end
