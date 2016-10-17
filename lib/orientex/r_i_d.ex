defmodule Orientex.RID do
  @moduledoc false

  defstruct cluster_id: nil, cluster_position: nil
end

defimpl String.Chars, for: Orientex.RID do
  def to_string(%Orientex.RID{cluster_id: cluster_id, cluster_position: cluster_position}) do
    "##{cluster_id}:#{cluster_position}"
  end
end