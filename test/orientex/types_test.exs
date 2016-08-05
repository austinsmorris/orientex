defmodule Orientex.TypeTest do
  use ExUnit.Case

  alias Orientex.Types

  test "decode boolean false with trailing data" do
    {:ok, value, tail} = Types.decode(:boolean, <<0, 4>>)
    assert value == false
    assert tail == <<4>>
  end

  test "decode boolean false without trailing data" do
    {:ok, value, tail} = Types.decode(:boolean, <<0>>)
    assert value == false
    assert tail == <<>>
  end

  test "decode boolean true with trailing data" do
    {:ok, value, tail} = Types.decode(:boolean, <<1, 4>>)
    assert value == true
    assert tail == <<4>>
  end

  test "decode boolean true without trailing data" do
    {:ok, value, tail} = Types.decode(:boolean, <<1>>)
    assert value == true
    assert tail == <<>>
  end

  test "decode byte with trailing data" do
    {:ok, value, tail} = Types.decode(:byte, <<4, 7>>)
    assert value == 4
    assert tail == <<7>>
  end

  test "decode byte without trailing data" do
    {:ok, value, tail} = Types.decode(:byte, <<4>>)
    assert value == 4
    assert tail == <<>>
  end

  test "decode short with trailing data" do
    {:ok, value, tail} = Types.decode(:short, <<4, 7, 31>>)
    assert value == 1031
    assert tail == <<31>>
  end

  test "decode short without trailing data" do
    {:ok, value, tail} = Types.decode(:short, <<200, 7>>)
    assert value == -14329
    assert tail == <<>>
  end

  test "decode int with trailing data" do
    {:ok, value, tail} = Types.decode(:int, <<4, 7, 3, 1, 13>>)
    assert value == 67568385
    assert tail == <<13>>
  end

  test "decode int without trailing data" do
    {:ok, value, tail} = Types.decode(:int, <<200, 7, 3, 1>>)
    assert value == -939064575
    assert tail == <<>>
  end

  test "decode long with trailing data" do
    {:ok, value, tail} = Types.decode(:long, <<4, 7, 4, 7, 47, 47, 4, 7, 31>>)
    assert value == 290205129891578887
    assert tail == <<31>>
  end

  test "decode long without trailing data" do
    {:ok, value, tail} = Types.decode(:long, <<200, 7, 4, 7, 47, 47, 4, 7>>)
    assert value == -4033250512384097273
    assert tail == <<>>
  end

  test "decode bytes decodes like binary" do
    {:ok, value, tail} = Types.decode(:bytes, <<0, 0, 0, 2, 97, 98>>)
    assert value == <<97, 98>>
    assert tail == <<>>
  end

  test "decode string decodes like binary" do
    {:ok, value, tail} = Types.decode(:string, <<0, 0, 0, 2, 97, 98>>)
    assert value == "ab"
    assert tail == <<>>
  end

  test "decode record decodes like binary data" do
    {:ok, value, tail} = Types.decode(:record, <<0, 0, 0, 2, 97, 98>>)
    assert value == <<97, 98>>
    assert tail == <<>>
  end

  test "decode binary with trailing data" do
    {:ok, value, tail} = Types.decode(:binary, <<0, 0, 0, 2, 97, 98, 4>>)
    assert value == <<97, 98>>
    assert tail == <<4>>
  end

  test "decode binary without trailing data" do
    {:ok, value, tail} = Types.decode(:binary, <<0, 0, 0, 2, 97, 98>>)
    assert value == <<97, 98>>
    assert tail == <<>>
  end

  test "decode binary nil " do
    {:ok, value, tail} = Types.decode(:binary, <<-1 ::signed-size(32)>>)
    assert value == nil
    assert tail == <<>>
  end

  test "decode incomplete binary length" do
    {:incomplete, nil, tail} = Types.decode(:binary, <<0, 0, 1>>)
    assert tail == <<0, 0, 1>>
  end

  test "decode incomplete binary data" do
    {:incomplete, nil, tail} = Types.decode(:binary, <<0, 0, 0, 2, 97>>)
    assert tail == <<0, 0, 0, 2, 97>>
  end

  # test "decode compound types" do
  #
  # end

  test "encode nil" do
    encoded = Types.encode(nil)
    assert encoded == <<-1 ::signed-size(32)>>
  end

  test "encode false" do
    encoded = Types.encode(false)
    assert encoded == <<0>>
  end

  test "encode true" do
    encoded = Types.encode(true)
    assert encoded == <<1>>
  end

  test "encode byte with binary data" do
    encoded = Types.encode({:byte, "a"})
    assert encoded == <<97>>
  end

  test "encode byte with integer" do
    encoded = Types.encode({:byte, 4})
    assert encoded == <<4>>
  end

  test "encode short" do
    encoded = Types.encode({:short, 165})
    assert encoded == <<165 :: signed-size(16)>>
  end

  test "encode int" do
    encoded = Types.encode({:int, 25_281})
    assert encoded == <<25_281 :: signed-size(32)>>
  end

  test "encode long" do
    encoded = Types.encode({:long, 45_234_234})
    assert encoded == <<45_234_234 :: signed-size(64)>>
  end

  test "encode bytes encodes like binary" do
    encoded = Types.encode({:bytes, <<97, 97>>})
    assert encoded == <<0, 0, 0, 2, 97, 97>>
  end

  test "encode string encodes like binary" do
    encoded = Types.encode({:string, "aa"})
    assert encoded == <<0, 0, 0, 2, 97, 97>>
  end

  test "encode binary" do
    encoded = Types.encode({:binary, <<97, 97>>})
    assert encoded == <<0, 0, 0, 2, 97, 97>>
  end

  test "encode strings" do
    encoded = Types.encode({:strings, ["aa", "bb", "c"]})
    assert encoded == <<0, 0, 0, 3, 0, 0, 0, 2, 97, 97, 0, 0, 0, 2, 98, 98, 0, 0, 0, 1, 99>>
  end

  test "encode list encodes items in list" do
    encoded = Types.encode([nil, true, {:short, 165}, {:string, "aa"}])
    assert encoded == <<-1 :: signed-size(32), 1, 165 :: signed-size(16), 0, 0, 0, 2, 97, 97>>
  end
end
