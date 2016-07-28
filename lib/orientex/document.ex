defmodule Orientex.Document do
  @moduledoc false

  alias Orientex.RID

  defstruct class: nil, properties: nil, rid: %RID{}, version: :nil
end
