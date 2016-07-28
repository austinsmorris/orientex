defmodule Orientex.RIDTest do
  use ExUnit.Case

  alias Orientex.RID

  test "RID struct" do
    rid = %RID{}
    assert rid.cluster_id == nil
    assert rid.cluster_position == nil
  end
end
