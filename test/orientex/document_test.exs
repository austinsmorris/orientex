defmodule Orientex.DocumentTest do
  use ExUnit.Case

  alias Orientex.Document

  test "Document struct" do
    document = %Document{}
    assert document.class == nil
    assert document.properties == nil
    assert document.rid.cluster_id == nil
    assert document.rid.cluster_position == nil
    assert document.version == nil
  end
end
