defmodule Orientex.RIDTest do
  use ExUnit.Case

  alias Orientex.RID

  test "RID struct" do
    rid = %RID{}
    assert rid.cluster_id == nil
    assert rid.cluster_position == nil
  end

  test "String.Chars implementation" do
    rid = %RID{cluster_id: 123, cluster_position: 4567}
    assert "#{rid}" == "#123:4567"
  end
end
