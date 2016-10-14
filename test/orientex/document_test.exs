defmodule Orientex.DocumentTest do
  use ExUnit.Case

  alias Orientex.Document
  alias Orientex.RID

  test "Document struct" do
    document = %Document{}
    assert document.class == nil
    assert document.properties == nil
    assert document.rid == %RID{}
    assert document.version == nil
  end
end
