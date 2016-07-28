defmodule Orientex.Tokenizer do
  @moduledoc false
  
  alias Orientex.Schema
  alias Orientex.Types

  def tokenize(%Schema{result: result}, <<>>), do: {:ok, Enum.reverse(result)}
  def tokenize(%Schema{schema: [type | schema_tail]} = schema, data) do
    case do_tokenize_with_progress(schema, data) do
      {:ok, value, tail} ->
        tokenize(%Schema{result: [value | schema.result], schema: schema_tail}, tail)
      {:incomplete, nil, tail} ->
        {:incomplete, schema, tail}
      {:incomplete, value, tail} ->
        {:incomplete, %Schema{progress: value, result: schema.result, schema: schema.schema}, tail}
    end
  end

  defp do_tokenize_with_progress(%Schema{progress: [], schema: [type| _]}, data) do
    Types.decode(type, data)
  end
  defp do_tokenize_with_progress(%Schema{progress: progress, schema: [type| _]}, data) do
    Types.decode(type, progress, data)
  end
end
