defmodule Orientex.Schema.Command do
  @moduledoc false

  # todo - this is an implementation of a behavior or protocol or some interface thingy
  def get_schema() do
    # todo - encapsulate/abstract away the standard response header
    [:byte, :int, :byte, {:int, [:short, :byte, :short, :long, :int, :record]}, :byte]
  end
end
