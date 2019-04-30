defmodule StructtestTest do
  use ExUnit.Case
  doctest Structtest

  test "greets the world" do
    assert Structtest.hello() == :world
  end

  test "test  dealName" do
    assert Structtest.dealName(%Structtest{}) == "zhangmin"
  end
end
