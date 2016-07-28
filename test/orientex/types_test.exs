defmodule Orientex.TypeTest do
  use ExUnit.Case

  alias Orientex.Types

  test "decode boolean false with trailing data" do
    {:ok, boolean, tail} = Types.decode(:boolean, <<0, 4>>)
    assert boolean == false
    assert tail == <<4>>
  end

  test "decode boolean false without trailing data" do
    {:ok, boolean, tail} = Types.decode(:boolean, <<0>>)
    assert boolean == false
    assert tail == <<>>
  end

  test "decode boolean true with trailing data" do
    {:ok, boolean, tail} = Types.decode(:boolean, <<1, 4>>)
    assert boolean == true
    assert tail == <<4>>
  end

  test "decode boolean true without trailing data" do
    {:ok, boolean, tail} = Types.decode(:boolean, <<1>>)
    assert boolean == true
    assert tail == <<>>
  end

  test "decode byte with trailing data" do
    {:ok, byte, tail} = Types.decode(:byte, <<4, 7>>)
    assert byte == 4
    assert tail == <<7>>
  end

  test "decode byte without trailing data" do
    {:ok, byte, tail} = Types.decode(:byte, <<4>>)
    assert byte == 4
    assert tail == <<>>
  end

  test "decode short with trailing data" do
    {:ok, short, tail} = Types.decode(:short, <<4, 7, 31>>)
    assert short == 1031
    assert tail == <<31>>
  end

  test "decode short without trailing data" do
    {:ok, short, tail} = Types.decode(:short, <<200, 7>>)
    assert short == -14329
    assert tail == <<>>
  end

  test "decode int with trailing data" do
    {:ok, int, tail} = Types.decode(:int, <<4, 7, 3, 1, 13>>)
    assert int == 67568385
    assert tail == <<13>>
  end

  test "decode int without trailing data" do
    {:ok, int, tail} = Types.decode(:int, <<200, 7, 3, 1>>)
    assert int == -939064575
    assert tail == <<>>
  end

  test "decode long with trailing data" do
    {:ok, long, tail} = Types.decode(:long, <<4, 7, 4, 7, 47, 47, 4, 7, 31>>)
    assert long == 290205129891578887
    assert tail == <<31>>
  end

  test "decode long without trailing data" do
    {:ok, long, tail} = Types.decode(:long, <<200, 7, 4, 7, 47, 47, 4, 7>>)
    assert long == -4033250512384097273
    assert tail == <<>>
  end
end
