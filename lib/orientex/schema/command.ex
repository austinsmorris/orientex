defmodule Orientex.Schema.Command do
  @moduledoc false

  # todo - this is an implementation of a behavior or protocol or some interface thingy
  def get_schema() do
    # todo - encapsulate/abstract away the standard response header
    [:byte, :int, :byte, &get_schema_for_result_type/1]
  end

  defp get_schema_for_result_type(108) do # 108 is the byte for "l" (list of records)
    [{:int, [:short, :byte, :short, :long, :int, :record]}, :byte]
  end
  defp get_schema_for_result_type(110) do # 110 is the byte for "n" (null result)
    [:byte]
  end
  defp get_schema_for_result_type(119) do # 119 is the byte for "w" (wrapped single record)
    [[:short, :byte, :short, :long, :int, :record], :byte]
  end
end
