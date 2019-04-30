defmodule Structtest do
  @moduledoc """
  Documentation for Structtest.
  """


  defstruct name: "zhangmin", age: 23

  def dealName(%Structtest{name: name}) do
    name
  end





  @doc """
  Hello world.

  ## Examples

      iex> Structtest.hello()
      :world

  """
  def hello do
    :world
  end
end
