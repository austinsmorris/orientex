defmodule Orientex.Schema.Connect do
  @moduledoc false

  # todo - this is an implementation of a behavior or protocol or some interface thingy
  def get_schema() do
    # todo - encapsulate/abstract away the standard response header
    [:byte, :int, :int, :bytes]
  end
end
