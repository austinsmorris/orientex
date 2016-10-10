defmodule Orientex.TypesTest do
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

  test "encode list encodes items in list" do
    encoded = Types.encode([nil, true, {:short, 165}, {:string, "aa"}])
    assert encoded == <<-1 :: signed-size(32), 1, 165 :: signed-size(16), 0, 0, 0, 2, 97, 97>>
  end

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

  test "encode string nil encodes like empty string" do
    encoded = Types.encode({:string, nil})
    assert encoded == <<0, 0, 0, 0>>
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

  test "encode record" do
    assert false
  end

  test "get data type for boolean" do
    data_type = Types.get_data_type(:boolean)
    assert data_type == 0
  end

  test "get data type for int" do
    data_type = Types.get_data_type(:int)
    assert data_type == 1
  end

  test "get data type for short" do
    data_type = Types.get_data_type(:short)
    assert data_type == 2
  end

  test "get data type for long" do
    data_type = Types.get_data_type(:long)
    assert data_type == 3
  end

  test "get data type for float" do
    data_type = Types.get_data_type(:float)
    assert data_type == 4
  end

  test "get data type for double" do
    data_type = Types.get_data_type(:double)
    assert data_type == 5
  end

  test "get data type for datetime" do
    data_type = Types.get_data_type(:datetime)
    assert data_type == 6
  end

  test "get data type for string" do
    data_type = Types.get_data_type(:string)
    assert data_type == 7
  end

  test "get data type for binary" do
    data_type = Types.get_data_type(:binary)
    assert data_type == 8
  end

  test "get data type for embedded" do
    data_type = Types.get_data_type(:embedded)
    assert data_type == 9
  end

  test "get data type for embedded_list" do
    data_type = Types.get_data_type(:embedded_list)
    assert data_type == 10
  end

  test "get data type for embedded_set" do
    data_type = Types.get_data_type(:embedded_set)
    assert data_type == 11
  end

  test "get data type for embedded_map" do
    data_type = Types.get_data_type(:embedded_map)
    assert data_type == 12
  end

  test "get data type for link" do
    data_type = Types.get_data_type(:link)
    assert data_type == 13
  end

  test "get data type for link_list" do
    data_type = Types.get_data_type(:link_list)
    assert data_type == 14
  end

  test "get data type for link_set" do
    data_type = Types.get_data_type(:link_set)
    assert data_type == 15
  end

  test "get data type for link_map" do
    data_type = Types.get_data_type(:link_map)
    assert data_type == 16
  end

  test "get data type for byte" do
    data_type = Types.get_data_type(:byte)
    assert data_type == 17
  end

  test "get data type for transient" do
    data_type = Types.get_data_type(:transient)
    assert data_type == 18
  end

  test "get data type for date" do
    data_type = Types.get_data_type(:date)
    assert data_type == 19
  end

  test "get data type for custom" do
    data_type = Types.get_data_type(:custom)
    assert data_type == 20
  end

  test "get data type for decimal" do
    data_type = Types.get_data_type(:decimal)
    assert data_type == 21
  end

  test "get data type for link_bag" do
    data_type = Types.get_data_type(:link_bag)
    assert data_type == 22
  end

  test "get data type for any" do
    data_type = Types.get_data_type(:any)
    assert data_type == 23
  end
end
