defmodule Structtest do
  @moduledoc """
  Documentation for Structtest.
  """
  require Myhttpoison

  defstruct name: "zhangmin", age: 23

  def dealName(%Structtest{name: name}) do
    name
  end

  def paraTest([1 | re]) do
    re
  end

  @spec paraTestall(nonempty_maybe_improper_list()) :: nonempty_maybe_improper_list()
  def paraTestall([1 | re] = all) do
    all
  end

  def withtest(name \\ :na) do
    with value <-  Map.get(%{:na => "hh", :nn => 0},name,"jj")
    do
      value
    end
  end


  # [1,2,3] |> fn li ->
  #   def inlinetest do
  #     1
  #   end
  #   IO.puts(inspect(li, opts \\ []))
  # end

  def callMyhttpoison() do
    # inlinetest()
    url = "https://www.iroowe.com/2018/07/erlang%E7%9A%84http_client%E7%9A%84%E9%80%89%E6%8B%A9/"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end


  def testmapstruct() do
    Map.merge(%Structtest{}, %{age: 11})
  end

  # Myhttpoison.hh()
  # |> Enum.each(fn %{a, b} ->
  #   def genfun(%{unquote(a) => unquote(b)} = all) do
  #     IO.puts "#{inspect all, pretty: true}"
  #   end
  # end).()

  # def callHh() do
  #   Myhttpoison.hh()
  # end

  # def callF() do
  #   f()
  # end

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
