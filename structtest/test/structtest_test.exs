defmodule StructtestTest do
  use ExUnit.Case
  doctest Structtest

  test "greets the world" do
    assert Structtest.hello() == :world
  end

  test "test  dealName" do
    assert Structtest.dealName(%Structtest{}) == "zhangmin"
  end



  test "test  paraTest" do
    assert Structtest.paraTest([1,2,3]) == [2,3]
  end

  test "test  paraTestall" do
    assert Structtest.paraTestall([1,2,3]) == [1,2,3]
  end

  test "test  withtest" do
    assert Structtest.withtest() == "hh"
  end

  test "test  Enum.any?/2" do
    assert Enum.any?([1,2,3], &rem(&1, 2) == 0 ) == true
  end

  #这个测试说明Enum.reduce/2 会把第一个参数的第一个值给fun的acc，第二个值给x
  test "test  Enum.reduce([1, 2, 3, 4], fn x, acc -> x * acc end) " do
    fun = fn x, acc ->
      IO.puts "x: #{inspect x}  acc: #{inspect acc}"
       x * acc
    end
    assert Enum.reduce([1, 2, 3, 4], fun) == 24
  end

  test "HTTPoison" do
    url = "https://www.iroowe.com/2018/07/erlang%E7%9A%84http_client%E7%9A%84%E9%80%89%E6%8B%A9/"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
    assert 1 == 1
  end


  test "testmapstruct" do
    assert Structtest.testmapstruct == %{name: "zhangmin", age: 11}
  end

end
