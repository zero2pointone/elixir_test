defmodule RanchtestTest do
  use ExUnit.Case
  doctest Ranchtest

  test "greets the world" do
    assert Ranchtest.hello() == :world
  end
end
