defmodule Orientex.Query do
  @moduledoc false

  defstruct name: "", request: nil, session_id: nil, statement: ""
end

defimpl DBConnection.Query, for: Orientex.Query do
  alias Orientex.Query
  alias Orientex.Request
  alias Orientex.Response

  # todo - test
  @spec parse(query :: any, opts :: Keyword.t) :: any
  def parse(%Query{name: name} = query, _opts) do
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
  @spec decode(query :: any, result :: any, Keyword.t) :: any
  def decode(%Orientex.Query{request: request}, result, opts) do
    # mapper = opts[:decode_mapper] || fn x -> x end
    # response = Response.decode(request, result)
    # rows = do_decode(response, mapper)
    # %Response{response | rows: rows}
    Response.decode(request, result)
  end

  # defp do_decode(result, mapper) do
  #   IO.puts "Orientex.Query.do_decode()"
  #   IO.inspect result
  #   IO.inspect mapper
  # end
end

defimpl String.Chars, for: Orientex.Query do
  def to_string(%Orientex.Query{statement: statement}) do
    IO.iodata_to_binary(statement)
  end
end
